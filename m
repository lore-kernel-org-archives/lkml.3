Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307Ab3HZWhZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 18:37:25 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:54577 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634Ab3HZWhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 18:37:23 -0400
Message-ID: <521BD89E.1010703@gmail.com>
Date: Tue, 27 Aug 2013 00:37:18 +0200
From: Gabriel de Perthuis <g2p.code@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Kent Overstreet <kmo@daterainc.com>
CC: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bcache: register_quiet should still report errors
References: <521BD3C0.9070209@gmail.com> <1377556306-29938-1-git-send-email-g2p.code@gmail.com>
In-Reply-To: <1377556306-29938-1-git-send-email-g2p.code@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> register_quiet should still report all errors except
> "device already registered".
>
> Before this some potential errors would be silenced.

This can replace my other patch in this thread.
Switching /lib/udev/bcache-register to register_quiet
without this kernel patch will suppress the aforementioned errors,
but they probably aren't too common so we can live with it.
