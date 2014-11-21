Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407AbaKUIjY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 03:39:24 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:48304 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbaKUIjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 03:39:23 -0500
Message-ID: <546EFA2D.1030902@gmail.com>
Date: Fri, 21 Nov 2014 09:39:09 +0100
From: Harald Hoyer <harald.hoyer@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: kdbus: add code for buses, domains and endpoints
References: <1416546149-24799-1-git-send-email-gregkh@linuxfoundation.org> <1416546149-24799-10-git-send-email-gregkh@linuxfoundation.org>
In-Reply-To: <1416546149-24799-10-git-send-email-gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.11.2014 06:02, Greg Kroah-Hartman wrote:
> From: Daniel Mack <daniel@zonque.org>
> 
…
> +/**
> + * kdbus_bus_new() - create a kdbus_cmd_make from user-supplied data
> + * @domain:		The domain to work on
> + * @make:		Information as passed in by userspace
> + * @uid:		The uid of the device node
> + * @gid:		The gid of the device node

"device node" in several function comments.

