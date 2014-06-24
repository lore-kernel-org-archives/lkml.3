Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211AbaFXQAa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 12:00:30 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:34790 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753784AbaFXQA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 12:00:27 -0400
X-Sasl-enc: xM5rVoLgPNjlwKXoqcU/AQ050gLbO9R+HE2oSEQhYYMx 1403625624
Date: Tue, 24 Jun 2014 12:00:13 -0400
From: Greg KH <greg@kroah.com>
To: Ben Skeggs <skeggsb@gmail.com>
Cc: Ilia Mirkin <imirkin@alum.mit.edu>,
        kernel list <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Ben Skeggs <bskeggs@redhat.com>, Pavel Machek <pavel@ucw.cz>
Subject: Re: unparseable, undocumented /sys/class/drm/.../pstate
Message-ID: <20140624160013.GA27103@kroah.com>
References: <20140621180201.GA4621@amd.pavel.ucw.cz>
 <CAKb7UvhOCiBHcsB6a0qKBNsC3c9pmb=Wc7zucbBuP6vt-tx2eA@mail.gmail.com>
 <20140621194538.GA4903@kroah.com>
 <CAKb7UvjhOystpeRy1nQx49Nspve4wHQPb+e7gJQ-RT-HseK4Cw@mail.gmail.com>
 <20140623130259.GA29809@amd.pavel.ucw.cz>
 <CAKb7UvhmatCtu2rEHgVOjitN1gAPTsgfaUmA2iOLX2Qwhi+Yxg@mail.gmail.com>
 <20140623201503.GA4551@amd.pavel.ucw.cz>
 <CAKb7UvjU+MvW+rXi8488GE64Exuxj3+H5V+E8fzfL5fTb1CGMA@mail.gmail.com>
 <20140623202615.GA29199@kroah.com>
 <CACAvsv7t4A6o_-TQxz-jXAvm0fwOLSidpo1Jw01kVCdX3EpaaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACAvsv7t4A6o_-TQxz-jXAvm0fwOLSidpo1Jw01kVCdX3EpaaQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 10:06:06AM +1000, Ben Skeggs wrote:
> 
> But, as I said on IRC yesterday, let's just move this to debugfs to
> save this waste of time argument, and move on.

I like that idea, great plan :)

greg k-h
