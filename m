Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936665Ab3DIBXT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 21:23:19 -0400
Received: from intranet.asianux.com ([58.214.24.6]:42024 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936057Ab3DIBXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 21:23:16 -0400
X-Spam-Score: -100.7
Message-ID: <51636D60.8060809@asianux.com>
Date: Tue, 09 Apr 2013 09:22:40 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: drbd-dev@lists.linbit.com, drbd-user@lists.linbit.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/block/drbd: remove erroneous semicolon
References: <5152980D.8090903@asianux.com> <515BE19F.2080709@asianux.com> <20130408204510.GB13761@soda.linbit>
In-Reply-To: <20130408204510.GB13761@soda.linbit>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年04月09日 04:45, Lars Ellenberg wrote:
> On Wed, Apr 03, 2013 at 04:00:31PM +0800, Chen Gang wrote:
>> > Hello maintainers:
>> > 
>> >   when you have time, please help to check this patch whether is OK.
>> > 
>> >   thanks.
> Thanks.
> 
> It has already been queued in:
> http://git.kernel.dk/?p=linux-block.git;a=commit;h=0b6ef4164f50698eee536903d69d086add1a7889
> 

  ok thanks.

  it seems I am a little earlier than the link's patch.
    I found it on Wed 27 Mar 2013 14:56
    link's patch found it on Wed 27 Mar 2013 21:08

  ;-)


  but that's all right, it doesn't matter.

  thanks.

  :-)

gchen.


>> > On 2013年03月27日 14:56, Chen Gang wrote:
>>> > > 
>>> > >   need remove it, or always return -EBUSY.
>>> > >   it is found by compiler with 'EXTRA_CFLAG=-W'.
>>> > > 
>>> > > Signed-off-by: Chen Gang <gang.chen@asianux.com>
>>> > > ---
>>> > >  drivers/block/drbd/drbd_actlog.c |    2 +-
>>> > >  1 files changed, 1 insertions(+), 1 deletions(-)
>>> > > 
>>> > > diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
>>> > > index 6afe173..6608076 100644
>>> > > --- a/drivers/block/drbd/drbd_actlog.c
>>> > > +++ b/drivers/block/drbd/drbd_actlog.c
>>> > > @@ -389,7 +389,7 @@ int drbd_al_begin_io_nonblock(struct drbd_conf *mdev, struct drbd_interval *i)
>>> > >  		if (unlikely(tmp != NULL)) {
>>> > >  			struct bm_extent  *bm_ext = lc_entry(tmp, struct bm_extent, lce);
>>> > >  			if (test_bit(BME_NO_WRITES, &bm_ext->flags)) {
>>> > > -				if (!test_and_set_bit(BME_PRIORITY, &bm_ext->flags));
>>> > > +				if (!test_and_set_bit(BME_PRIORITY, &bm_ext->flags))
>>> > >  					return -EBUSY;
>>> > >  				return -EWOULDBLOCK;
>>> > >  			}
>>> > > 
> 


-- 
Chen Gang

Asianux Corporation
