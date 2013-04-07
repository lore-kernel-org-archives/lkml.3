Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751125Ab3DGEKB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 00:10:01 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:53932 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1749667Ab3DGEKA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 00:10:00 -0400
Message-ID: <1365307798.8922.11.camel@joe-AO722>
Subject: Re: [PATCH] drivers/gpu/drm/nouveau: remove erroneous semicolon
From: Joe Perches <joe@perches.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, airlied@linux.ie, bskeggs@redhat.com,
        airlied@redhat.com, dri-devel@lists.freedesktop.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sat, 06 Apr 2013 21:09:58 -0700
In-Reply-To: <5160EEA6.3090505@asianux.com>
References: <51529E77.2010906@asianux.com> <515BE1E7.7070905@asianux.com>
	 <5160C5FB.8030409@asianux.com> <20130407034943.GA8159@kroah.com>
	 <5160EEA6.3090505@asianux.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-04-07 at 11:57 +0800, Chen Gang wrote:
> On 2013年04月07日 11:49, Greg KH wrote:
> > On Sun, Apr 07, 2013 at 09:03:55AM +0800, Chen Gang wrote:
> >> Hello Greg KH:
> >>   when you have time, can you help to check this patch whether OK ?
> > No.
> Why ?  does it also need a test ??

Greg's not the nouveau maintainer/babysitter and
likely doesn't have the time/hardware/desire to
test it.

The patch should be simply be sent to David Airlie
and dri-devel.

It is a pretty obvious typo though.


