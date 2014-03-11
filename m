Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123AbaCKRPQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 13:15:16 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:47946
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752325AbaCKRPM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 13:15:12 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371Ic89bh936eI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2149h2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2fh95h839h93fhc61hd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h2336h2438h2461h2487h24d7h2516h2545h255eh25f6h2605h906i1155h)
Date: Tue, 11 Mar 2014 10:15:02 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Dirk Brandewie <dirk.brandewie@gmail.com>
CC: Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Joe Perches <joe@perches.com>,
        <cpufreq@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>
Subject: Re: [PATCH v2] cpufreq: Reformat printk() statements
References: <1394557380-15054-1-git-send-email-soren.brinkmann@xilinx.com>
 <531F441C.5070107@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <531F441C.5070107@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <c05f44ed-dff6-45b6-96eb-3f4e37ffee9b@CH1EHSMHS035.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-11 at 10:13AM -0700, Dirk Brandewie wrote:
> On 03/11/2014 10:03 AM, Soren Brinkmann wrote:
> >From: Joe Perches <joe@perches.com>
> >
> >  - Add missing newlines
> >  - Coalesce format fragments
> >  - Convert printks to pr_<level>
> >  - Align arguments
> >
> 
> This introduces a bunch of lines over 80 charaters long.

Right, intentionally. It is more important to be able to grep for
printed messages than staying within 80 chars. That was the reason to
create this patch in the first place (I probably should have left that
note in the commit message).

	Sören


