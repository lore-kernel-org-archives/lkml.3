Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563Ab3E0Gig (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 02:38:36 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:47418 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754364Ab3E0Gif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 02:38:35 -0400
Message-ID: <1369636713.1904.8.camel@dabdike>
Subject: Re: [PATCH 04/24] drivers/scsi/initio: Convert to module_pci_driver
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Libo Chen <libo.chen@huawei.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        lizefan@huawei.com, gregkh@linuxfoundation.org
Date: Sun, 26 May 2013 23:38:33 -0700
In-Reply-To: <1369621717-5860-1-git-send-email-libo.chen@huawei.com>
References: <1369621717-5860-1-git-send-email-libo.chen@huawei.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-05-27 at 10:28 +0800, Libo Chen wrote:
> use module_pci_driver instead of init/exit, make code clean.

For the ancient drivers, like this, the principal is that we really
don't touch except for tested bug fixes.  For the current ones (like
mvumi) it's up to the maintainer.

James


