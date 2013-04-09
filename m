Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936927Ab3DIP4Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 11:56:16 -0400
Received: from zimbra.linbit.com ([212.69.161.123]:41318 "EHLO
	zimbra.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760719Ab3DIP4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 11:56:15 -0400
Date: Tue, 9 Apr 2013 17:56:13 +0200
From: Lars Ellenberg <lars.ellenberg@linbit.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: drbd-dev@lists.linbit.com, drbd-user@lists.linbit.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Drbd-dev] [PATCH] drivers/block/drbd: remove erroneous semicolon
Message-ID: <20130409155613.GG13761@soda.linbit>
Mail-Followup-To: Chen Gang <gang.chen@asianux.com>,
	drbd-dev@lists.linbit.com, drbd-user@lists.linbit.com,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <5152980D.8090903@asianux.com>
 <515BE19F.2080709@asianux.com>
 <20130408204510.GB13761@soda.linbit>
 <51636D60.8060809@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51636D60.8060809@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 09:22:40AM +0800, Chen Gang wrote:
> On 2013年04月09日 04:45, Lars Ellenberg wrote:
> > On Wed, Apr 03, 2013 at 04:00:31PM +0800, Chen Gang wrote:
> >> > Hello maintainers:
> >> > 
> >> >   when you have time, please help to check this patch whether is OK.
> >> > 
> >> >   thanks.
> > Thanks.
> > 
> > It has already been queued in:
> > http://git.kernel.dk/?p=linux-block.git;a=commit;h=0b6ef4164f50698eee536903d69d086add1a7889
> > 
> 
>   ok thanks.
> 
>   it seems I am a little earlier than the link's patch.
>     I found it on Wed 27 Mar 2013 14:56
>     link's patch found it on Wed 27 Mar 2013 21:08
> 

The original report (by kbuild test robot) is from the week before iirc
(don't have it anymore), the original commit in our drbd repo the day before.

But:

>   ;-)
> 
>   but that's all right, it doesn't matter.
> 
>   thanks.

 ;-)

