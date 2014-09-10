Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbaIJTSd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 15:18:33 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52461 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbaIJTSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 15:18:32 -0400
Date: Wed, 10 Sep 2014 20:18:25 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Maciej Matraszek <m.matraszek@samsung.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH] PM / Domains: add debugfs listing of struct
 generic_pm_domain-s
Message-ID: <20140910191825.GA7996@ZenIV.linux.org.uk>
References: <1410348536-15201-1-git-send-email-m.matraszek@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410348536-15201-1-git-send-email-m.matraszek@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 01:28:56PM +0200, Maciej Matraszek wrote:

> +static int pm_genpd_summary_open(struct inode *inode, struct file *file)
> +{
> +	return single_open(file, pm_genpd_summary_show, inode->i_private);
							^^^^^^^^^^^^^^^^
							what for?

Where in pm_genpd_summary_show() are you using ->private?
