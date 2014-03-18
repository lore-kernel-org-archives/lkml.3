Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226AbaCRIgS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 04:36:18 -0400
Received: from canardo.mork.no ([148.122.252.1]:47843 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753396AbaCRIgN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 04:36:13 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Ben Chan <benchan@chromium.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, Oliver Neukum <oliver@neukum.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Greg Suarez <gsuarez@smithmicro.com>
Subject: Re: [PATCH v3 1/2] USB: cdc: add MBIM extended functional descriptor structure
Organization: m
References: <1395115145-31821-1-git-send-email-benchan@chromium.org>
Date: Tue, 18 Mar 2014 09:35:57 +0100
In-Reply-To: <1395115145-31821-1-git-send-email-benchan@chromium.org> (Ben
	Chan's message of "Mon, 17 Mar 2014 20:59:04 -0700")
Message-ID: <87wqfrkioi.fsf@nemi.mork.no>
User-Agent: Gnus/5.130009 (Ma Gnus v0.9) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Chan <benchan@chromium.org> writes:

> This patch adds the MBIM extended functional descriptor structure
> defined in "Universal Serial Bus Communications Class Subclass
> Specification for Mobile Broadband Interface Model, Revision 1.0,
> Errata-1" published by USB-IF.
>
> Signed-off-by: Ben Chan <benchan@chromium.org>
> ---
> No changes from patch v1.

I believe you could have included Greg KH's ack then, to make sure it is
recorded.  Or will patchwork keep track of tags across different patch
versions?


Bjørn
