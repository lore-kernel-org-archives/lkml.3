Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab3INGLJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 02:11:09 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:60686 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978Ab3INGLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 02:11:07 -0400
MIME-Version: 1.0
In-Reply-To: <20130913080713.GI19211@elgon.mountain>
References: <20130913080713.GI19211@elgon.mountain>
Date: Sat, 14 Sep 2013 08:11:05 +0200
Message-ID: <CAJSP0QWB2jvRZccC=_nNrPbutSKv_a80J03K5WLGf8iWA1P13g@mail.gmail.com>
Subject: Re: [patch] staging: line6: add bounds check in snd_toneport_source_put()
From: Stefan Hajnoczi <stefanha@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 10:07 AM, Dan Carpenter
<dan.carpenter@oracle.com> wrote:
> "source" comes from the user in snd_ctl_elem_write() so it needs to be
> checked.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Reviewed-by: Stefan Hajnoczi <stefanha@gmail.com>
