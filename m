Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740AbbAEPj2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 10:39:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40132 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752979AbbAEPj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 10:39:27 -0500
Date: Mon, 5 Jan 2015 10:39:18 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Andrew Duggan <aduggan@synaptics.com>,
        Christopher Heiny <cheiny@synaptics.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: synaptics - switch ForcePad detection to PNP IDs
Message-ID: <20150105153918.GF19391@mail.corp.redhat.com>
References: <20141229225113.GA13847@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141229225113.GA13847@dtor-ws>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 29 2014 or thereabouts, Dmitry Torokhov wrote:
> According to Synaptics devices with ForcePads use SYN300D and SYN3014 as
> PNP IDs, so let's switch from DMI-bases detection scheme to PNP-based
> one, which should be more reliable.
> 
> Suggested-by: Hans de Goede <hdegoede@redhat.com>
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> ---

Looks good to me too:
Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Cheers,
Benjamin

