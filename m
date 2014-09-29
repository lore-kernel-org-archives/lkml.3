Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408AbaI2Swa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 14:52:30 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:56141 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538AbaI2Sw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 14:52:29 -0400
MIME-Version: 1.0
Date: Mon, 29 Sep 2014 14:52:28 -0400
Message-ID: <CAFeSpncUDXemk93j+6PR2p3cdOonAGqT4JZY3m3egKvTL081PA@mail.gmail.com>
Subject: Re: [PATCH 0/24] Introduce ff-memless-next as an improved replacement
 for ff-memless
From: Ghislain Bourgeois <ghislain.bourgeois@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ff-memless-next (MLNX) is a largely improved version of the current ff-memless
> (FFML) driver. MLNX supports all force feedback effects currently available in
> the Linux force feedback userspace API. All effects are handled in accordance
> with Microsoft's DirectInput/XInput.


I have been testing for a while using a Logitech DFGT (hid-lg4ff) with success.
All force feedback was working properly and I had no issues.

Ghislain

tested-by: Ghislain Bourgeois <ghislain.bourgeois [at] gmail>
