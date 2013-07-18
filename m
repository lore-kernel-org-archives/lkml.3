Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758732Ab3GRKxI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 06:53:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14508 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758368Ab3GRKxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 06:53:06 -0400
Date: Thu, 18 Jul 2013 12:55:51 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Ortwin =?iso-8859-1?Q?Gl=FCck?= <odi@odi.ch>
Cc: Arend van Spriel <arend@broadcom.com>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: [BUG] 3.10 regression: hang on suspend
Message-ID: <20130718105550.GA4628@redhat.com>
References: <51E4501D.3010001@odi.ch>
 <20130716065626.GA1587@redhat.com>
 <51E4F790.6090308@odi.ch>
 <51E51712.4020609@broadcom.com>
 <51E58FA5.4000804@odi.ch>
 <20130717122944.GA25894@redhat.com>
 <51E6E1AB.5010300@odi.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51E6E1AB.5010300@odi.ch>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 17, 2013 at 08:25:47PM +0200, Ortwin Glück wrote:
> On 07/17/2013 02:29 PM, Stanislaw Gruszka wrote:
> >This looks like livelock
> 
> OK got it. Just a GPF in the suspend path, not a livelock
> fortunately. With no_console_suspend the trace appears. Attached is
> a screenshot, transcription for your convenience is here:
> 
> NULL pointer deref at iwlagn_mac_remove_interface+0x43/0x120

Unfortunately I still don't know why this happen. Please do

objdump -r -d --prefix-addresses net/mac80211/mac80211.ko > mac80211.txt
objdump -r -d --prefix-addresses drivers/net/wireless/iwlwifi/dvm/iwldvm.ko > iwldvm.txt

and send me mac80211.txt & iwldvm.txt files.

Thanks
Stanislaw

