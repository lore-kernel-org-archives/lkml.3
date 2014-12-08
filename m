Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606AbaLHOH4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 09:07:56 -0500
Received: from tex.lwn.net ([70.33.254.29]:53364 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140AbaLHOHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 09:07:55 -0500
Date: Mon, 8 Dec 2014 09:07:52 -0500
From: Jonathan Corbet <corbet@lwn.net>
To: John de la Garza <john@jjdev.com>
Cc: gregkh@linuxfoundation.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kobject: grammar fix
Message-ID: <20141208090752.7865a478@lwn.net>
In-Reply-To: <20141206213855.GA28806@vega.jjdev.com>
References: <20141206213855.GA28806@vega.jjdev.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Dec 2014 16:38:57 -0500
John de la Garza <john@jjdev.com> wrote:

> -When the kobject is removed from the kernel (details on how to do that is
> +When the kobject is removed from the kernel (details on how to do that are

Makes sense, applied to the docs tree.

Thanks,

jon
