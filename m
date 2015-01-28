Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517AbbA1ULn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:11:43 -0500
Received: from tex.lwn.net ([70.33.254.29]:35190 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250AbbA1UKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:10:50 -0500
Date: Wed, 28 Jan 2015 12:08:50 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Yaowei Bai <bywxiaobai@163.com>
Cc: rjw@rjwysocki.net, lenb@kernel.org, linux-acpi@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation/acpi: add the missing '='
Message-ID: <20150128120850.5f6504a7@lwn.net>
In-Reply-To: <1421330356-4051-1-git-send-email-bywxiaobai@163.com>
References: <1421330356-4051-1-git-send-email-bywxiaobai@163.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2015 21:59:16 +0800
Yaowei Bai <bywxiaobai@163.com> wrote:

> -			.acpi_match_table  ACPI_PTR(mpu3050_acpi_match),
> +			.acpi_match_table = ACPI_PTR(mpu3050_acpi_match),

Applied to the docs tree, thanks.

jon
