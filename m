Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751240AbbALE4o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 23:56:44 -0500
Received: from mail-yh0-f49.google.com ([209.85.213.49]:34719 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbbALE4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 23:56:42 -0500
Date: Sun, 11 Jan 2015 20:56:38 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Julian Brost <linux-kernel@0x4a42.net>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, corbet@lwn.net,
        tomas.winkler@intel.com, linux-mei@linux.intel.com,
        linux-kernel@i4.cs.fau.de, fabian.hofmann@fau.de
Subject: Re: [PATCH 4/4] Documentation/misc-devices/mei: Fix indentation of
 embedded code.
Message-ID: <20150112045638.GA19607@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Julian Brost <linux-kernel@0x4a42.net>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, corbet@lwn.net,
	tomas.winkler@intel.com, linux-mei@linux.intel.com,
	linux-kernel@i4.cs.fau.de, fabian.hofmann@fau.de
References: <1421020689-28332-1-git-send-email-linux-kernel@0x4a42.net>
 <1421020689-28332-5-git-send-email-linux-kernel@0x4a42.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421020689-28332-5-git-send-email-linux-kernel@0x4a42.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julian,

On Mon, Jan 12, 2015 at 12:58:09AM +0100, Julian Brost wrote:
[...]
>  static struct mei_cl_driver contact_driver = {
> -       .id_table = contact_mei_tbl,
> -       .name = CONTACT_DRIVER_NAME,
> +	.id_table = contact_mei_tbl,
> +	.name = CONTACT_DRIVER_NAME,
>  
> -       .probe = contact_probe,
> -       .remove = contact_remove,
> +	.probe = contact_probe,
> +	.remove = contact_remove,
>  };
>  

Looking at this file the majority of the code is formatted at the left
with tabs.  So I think your change is in agreement with the current
design.

[...]

Reviewed-by: Jeremiah Mahler <jmmahler@gmail.com>

-- 
- Jeremiah Mahler
