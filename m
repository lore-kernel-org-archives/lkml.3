Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab3KUQDI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 11:03:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34637 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971Ab3KUQDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 11:03:06 -0500
Message-ID: <1385049781.1966.16.camel@deneb.redhat.com>
Subject: Re: [PATCH] arch: c6x: uapi: be sure of "_UAPI" prefix for all
 guard macros
From: Mark Salter <msalter@redhat.com>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: a-jacquiot@ti.com, viro@zeniv.linux.org.uk, linux-c6x-dev@linux-c6x.org,
        linux-kernel@vger.kernel.org
Date: Thu, 21 Nov 2013 11:03:01 -0500
In-Reply-To: <52889AC5.9000806@gmail.com>
References: <52889AC5.9000806@gmail.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-11-17 at 18:30 +0800, Chen Gang wrote:
> For all uapi headers, need use "_UAPI" prefix for its guard macro
> (which will be stripped by "scripts/headers_installer.sh").
> 
> Also be sure that all files have their guard macros.
> 
> Also be sure that all "#endif" are followed with correct comments.
> 
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>

Acked-by: Mark Salter <msalter@redhat.com>


