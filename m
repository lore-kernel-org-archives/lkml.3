Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163AbbAUMrK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 07:47:10 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:60032 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbbAUMq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 07:46:59 -0500
Date: Wed, 21 Jan 2015 04:46:55 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Ahmad Hassan <ahmad.hassan612@gmail.com>
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org, vinc94@gmail.com,
        roberta.dobrescu@gmail.com, sachin.kamat@samsung.com,
        ebru.akagunduz@gmail.com, damm+renesas@opensource.se,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] staging: emxx_udc: Replace ERR by dev_err
Message-ID: <20150121124655.GB4493@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Ahmad Hassan <ahmad.hassan612@gmail.com>,
	devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
	vinc94@gmail.com, roberta.dobrescu@gmail.com,
	sachin.kamat@samsung.com, ebru.akagunduz@gmail.com,
	damm+renesas@opensource.se, linux-kernel@vger.kernel.org
References: <cover.1421880617.git.ahmad.hassan612@gmail.com>
 <586bbf583754ad5db8967882631d98324b3127fa.1421880617.git.ahmad.hassan612@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <586bbf583754ad5db8967882631d98324b3127fa.1421880617.git.ahmad.hassan612@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ahmad,

On Wed, Jan 21, 2015 at 01:55:11PM -0900, Ahmad Hassan wrote:
[...]
>  	if (udc == NULL) {
> -		ERR("%s udc == NULL\n", __func__);
> +		dev_err(udc->dev,"%s udc == NULL\n", __func__);
                      ^^^^^

Always check your patches with checkpatch.pl before submitting them.

There are a bunch of "space required after ','" errors in this patch.

-- 
- Jeremiah Mahler
