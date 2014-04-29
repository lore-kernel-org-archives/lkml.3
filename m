Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758247AbaD2Ss3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 14:48:29 -0400
Received: from qmta15.emeryville.ca.mail.comcast.net ([76.96.27.228]:33133
	"EHLO qmta15.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751149AbaD2Ss2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 14:48:28 -0400
Date: Tue, 29 Apr 2014 13:48:25 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Fabian Frederick <fabf@skynet.be>
cc: linux-kernel <linux-kernel@vger.kernel.org>, Joe Perches <joe@perches.com>,
        akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] mm/slub.c: convert printk to pr_foo()
In-Reply-To: <20140429192752.a1e8a72849dc01324127d282@skynet.be>
Message-ID: <alpine.DEB.2.10.1404291348020.26056@gentwo.org>
References: <20140429192752.a1e8a72849dc01324127d282@skynet.be>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2014, Fabian Frederick wrote:

> -All printk(KERN_foo converted to pr_foo()
> -Default printk converted to pr_warn()
> -Coalesce format fragments

Acked-by: Christoph Lameter <cl@linux.com>
