Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138Ab3HFQ1N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 12:27:13 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50688 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755524Ab3HFQ1M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 12:27:12 -0400
From: "Etheridge, Darren" <detheridge@ti.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: David Airlie <airlied@linux.ie>, Rob Clark <robdclark@gmail.com>,
        "Russell King" <rmk+kernel@arm.linux.org.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 0/8] Several NXP TDA998x patches
Thread-Topic: [PATCH 0/8] Several NXP TDA998x patches
Thread-Index: AQHOkin/dIbfL8p72k2t8pqNwP/bNJmIXgDQ
Date: Tue, 6 Aug 2013 16:26:52 +0000
Message-ID: <1A80A2FD7F34484786E5DF71F3968B6940F54581@DLEE10.ent.ti.com>
References: <1375741218-10225-1-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1375741218-10225-1-git-send-email-sebastian.hesselbarth@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [128.247.5.50]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Hesselbarth [mailto:sebastian.hesselbarth@gmail.com]
> Subject: [PATCH 0/8] Several NXP TDA998x patches
> 
> This patch set picks up several patches sent during the past months related
> with NXP TDA998x HDMI transmitter driver. The patches have been tested
> on Marvell Dove (Armada DRM) on several HDMI modes with audio playing
> on S/PDIF. I have also quickly tested on Beaglebone Black (tilcdc) for one DVI
> mode.
> 
> As I squashed some patches and fixed some audio issues, it would be great
> to have a formal Tested-by or Acked-by from Russell and Darren for the
> whole patch set.
> 
Sebastian,

Thanks for consolidating all of these patches into a final series.  I am going to take them for a test drive on  BeagleBone Black and will follow up with my findings/tested-by.  Likely to be a couple of days because I am in the process of moving all my equipment into a new office.


Darren
