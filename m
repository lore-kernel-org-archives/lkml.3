Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751697AbaBHVQA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 16:16:00 -0500
Received: from canardo.mork.no ([148.122.252.1]:41331 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751680AbaBHVP6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 16:15:58 -0500
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Raymond Wanyoike <raymond.wanyoike@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] net: qmi_wwan: add ZTE MF667
Organization: m
References: <1391893262-25092-1-git-send-email-raymond.wanyoike@gmail.com>
Date: Sat, 08 Feb 2014 22:15:53 +0100
In-Reply-To: <1391893262-25092-1-git-send-email-raymond.wanyoike@gmail.com>
	(Raymond Wanyoike's message of "Sun, 9 Feb 2014 00:01:02 +0300")
Message-ID: <87wqh5gvau.fsf@nemi.mork.no>
User-Agent: Gnus/5.130009 (Ma Gnus v0.9) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Raymond Wanyoike <raymond.wanyoike@gmail.com> writes:

> The driver description files give these descriptions to the vendor specific
> ports on this modem:
>
>  VID_19D2&PID_1270&MI_00: "ZTE MF667 Diagnostics Port"
>  VID_19D2&PID_1270&MI_01: "ZTE MF667 AT Port"
>  VID_19D2&PID_1270&MI_02: "ZTE MF667 ATExt2 Port"
>  VID_19D2&PID_1270&MI_03: "ZTE MF667 ATExt Port"
>  VID_19D2&PID_1270&MI_04: "ZTE MF667 USB Modem"
>  VID_19D2&PID_1270&MI_05: "ZTE MF667 Network Adapter"
>
> Signed-off-by: Raymond Wanyoike <raymond.wanyoike@gmail.com>

Looks perfect to me.  Thanks.

Acked-by: Bjørn Mork <bjorn@mork.no>
