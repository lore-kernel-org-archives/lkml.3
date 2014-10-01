Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbaJAP52 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 11:57:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10149 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751516AbaJAP50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 11:57:26 -0400
Message-ID: <542C2460.8020208@redhat.com>
Date: Wed, 01 Oct 2014 17:57:20 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: Willem de Bruijn <willemb@google.com>, Dave Hansen <dave.hansen@intel.com>,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org
Subject: Re: [LKP] [net] 4ed2d765dfa:  ltp.recv01.4.TFAIL
References: <20141001152910.GA4440@wfg-t540p.sh.intel.com>
In-Reply-To: <20141001152910.GA4440@wfg-t540p.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2014 05:29 PM, Fengguang Wu wrote:
> Hi Willem,
>
> FYI, we noticed the below LTP failures on commit
>
> 4ed2d765dfaccff5ebdac68e2064b59125033a3b ("net-timestamp: TCP timestamping")

I think it already was discussed here:

   http://www.spinics.net/lists/netdev/msg297822.html
