Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512Ab3A3Nut (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 08:50:49 -0500
Received: from canardo.mork.no ([148.122.252.1]:57653 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753674Ab3A3Nur convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 08:50:47 -0500
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Daniele Palmas <dnlplm@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] NET: qmi_wwan: add Telit LE920 support
Organization: m
References: <1359550026-1879-1-git-send-email-dnlplm@gmail.com>
Date: Wed, 30 Jan 2013 14:50:46 +0100
In-Reply-To: <1359550026-1879-1-git-send-email-dnlplm@gmail.com> (Daniele
	Palmas's message of "Wed, 30 Jan 2013 13:47:06 +0100")
Message-ID: <8738xiok3t.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniele Palmas <dnlplm@gmail.com> writes:

> Add VID, PID and fixed interface for Telit LE920
>
> Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
> ---
> v2:
>  - rebased against net tree

Excellent! Thanks.  Looks like an interesting device BTW.

Acked-by: Bjørn Mork <bjorn@mork.no>
