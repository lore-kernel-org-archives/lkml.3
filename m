Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263AbaBZMNp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 07:13:45 -0500
Received: from canardo.mork.no ([148.122.252.1]:54766 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170AbaBZMNn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 07:13:43 -0500
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: freddy@asix.com.tw
Cc: netdev@vger.kernel.org, davem@davemloft.net, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] AX88179_178A: Add VID:DID for Lenovo OneLinkDock Gigabit LAN
Organization: m
References: <1393404871-2248-1-git-send-email-freddy@asix.com.tw>
Date: Wed, 26 Feb 2014 13:13:12 +0100
In-Reply-To: <1393404871-2248-1-git-send-email-freddy@asix.com.tw>
	(freddy@asix.com.tw's message of "Wed, 26 Feb 2014 16:54:31 +0800")
Message-ID: <87zjle6pif.fsf@nemi.mork.no>
User-Agent: Gnus/5.130009 (Ma Gnus v0.9) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

freddy@asix.com.tw writes:

> From: Freddy Xin <freddy@asix.com.tw>
>
> Add VID:DID for Lenovo OneLinkDock Gigabit LAN

This is the same patch Keith Packard sent, but with a slighly different
description.  I take that as another proof that we should not attempt to
describe devices in these drivers.  Describe the driver instead.




Bjørn
