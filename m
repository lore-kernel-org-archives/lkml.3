Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757062Ab3CFXNT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 18:13:19 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:39253 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116Ab3CFXNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 18:13:18 -0500
MIME-Version: 1.0
In-Reply-To: <1362610608-64885-1-git-send-email-s-anna@ti.com>
References: <1362610608-64885-1-git-send-email-s-anna@ti.com>
Date: Wed, 6 Mar 2013 15:13:17 -0800
X-Google-Sender-Auth: j47OzEchLpKeRJf9uNXD93sMNOU
Message-ID: <CAOS58YNbSC3BcU9HbMyhNcrfkxQwDDLUk57Kk5byyvM2_oPAGg@mail.gmail.com>
Subject: Re: [PATCH] remoteproc: fix the error check for idr_alloc
From: Tejun Heo <tj@kernel.org>
To: Suman Anna <s-anna@ti.com>
Cc: linux-kernel@vger.kernel.org, Ohad Ben-Cohen <ohad@wizery.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 6, 2013 at 2:56 PM, Suman Anna <s-anna@ti.com> wrote:
> The new idr_alloc interface returns the allocated id back
> on success, so fix the error path to check for negative
> values. This was missed out in the newer idr interface
> adoption patch, 15fc611 "remoteproc: convert to idr_alloc()".
>
> Signed-off-by: Suman Anna <s-anna@ti.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Ohad Ben-Cohen <ohad@wizery.com>

Acked-by: Tejun Heo <tj@kernel.org>

Sorry about that.

-- 
tejun
