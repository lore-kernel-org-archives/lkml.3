Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447AbaCBA7M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 19:59:12 -0500
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:52991 "EHLO
	qmta03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753335AbaCBA7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 19:59:10 -0500
Date: Sat, 1 Mar 2014 18:59:07 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: Jianyu Zhan <nasa4836@gmail.com>
cc: linux-mm@kvack.org, penberg@kernel.org, mpm@selenic.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/slab.c: cleanup outdated comments and unify variables
 naming
In-Reply-To: <20140227073258.GA11087@meta-silence.Home>
Message-ID: <alpine.DEB.2.10.1403011858040.14057@nuc>
References: <20140227073258.GA11087@meta-silence.Home>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Feb 2014, Jianyu Zhan wrote:

> As time goes, the code changes a lot, and this leads to that
> some old-days comments scatter around , which instead of faciliating
> understanding, but make more confusion. So this patch cleans up them.

Acked-by: Christoph Lameter <cl@linux.com>
