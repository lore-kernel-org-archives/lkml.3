Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbbAZROK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 12:14:10 -0500
Received: from p3plex2out04.prod.phx3.secureserver.net ([184.168.131.18]:37907
	"EHLO p3plex2out04.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752808AbbAZROI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 12:14:08 -0500
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Ian Abbott <abbotti@mev.co.uk>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 0/5] staging: comedi: 8255.[ch]: reformat comments
Thread-Topic: [PATCH 0/5] staging: comedi: 8255.[ch]: reformat comments
Thread-Index: AQHQOWuTXREdT78gFEmvLvGHnxUmMJzSo1Ow
Date: Mon, 26 Jan 2015 17:14:07 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D88260E5B53@P3PWEX4MB008.ex4.secureserver.net>
References: <1422278725-17740-1-git-send-email-abbotti@mev.co.uk>
In-Reply-To: <1422278725-17740-1-git-send-email-abbotti@mev.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [184.183.19.121]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 26, 2015 6:25 AM, Ian Abbott wrote:
> Reformat comments to usual style and add kerneldoc to exported
> functions.
>
> 1) staging: comedi: 8255.c: reformat copyright comment
> 2) staging: comedi: 8255.c: reformat comedi driver comment
> 3) staging: comedi: 8255.c: document subdev_8255_init() and _mm_init()
 >4) staging: comedi: 8255.c: reformat remaining block comments
> 5) staging: comedi: 8255.h: reformat copyright comment
>
> drivers/staging/comedi/drivers/8255.c | 174 ++++++++++++++++++++--------------
> drivers/staging/comedi/drivers/8255.h |  32 +++----
> 2 files changed, 117 insertions(+), 89 deletions(-)

Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>

