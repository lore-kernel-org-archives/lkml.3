Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597AbaHUDZJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 23:25:09 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:65333 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362AbaHUDZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 23:25:07 -0400
Date: Wed, 20 Aug 2014 20:25:01 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Mark Einon <mark.einon@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 8/8] staging: et131x: Implement NAPI support
Message-ID: <20140820202501.558fdb3f@uryu.home.lan>
In-Reply-To: <1408573078-9320-9-git-send-email-mark.einon@gmail.com>
References: <1408573078-9320-1-git-send-email-mark.einon@gmail.com>
	<1408573078-9320-9-git-send-email-mark.einon@gmail.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Aug 2014 23:17:58 +0100
Mark Einon <mark.einon@gmail.com> wrote:

>  
> +	if (budget > MAX_PACKETS_HANDLED)
> +		limit = MAX_PACKETS_HANDLED;

Why this artificial restriction?
