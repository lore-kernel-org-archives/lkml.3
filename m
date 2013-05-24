Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803Ab3EXNSx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 09:18:53 -0400
Received: from canardo.mork.no ([148.122.252.1]:60194 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752699Ab3EXNSv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 09:18:51 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Richard Weinberger <richard@nod.at>
Cc: gregkh@linuxfoundation.org, dcbw@redhat.com, jhovold@gmail.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial: Add Option GTM681W to qcserial device table.
Organization: m
References: <1369389711-4290-1-git-send-email-richard@nod.at>
Date: Fri, 24 May 2013 15:18:21 +0200
In-Reply-To: <1369389711-4290-1-git-send-email-richard@nod.at> (Richard
	Weinberger's message of "Fri, 24 May 2013 12:01:51 +0200")
Message-ID: <87obc0frdu.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Weinberger <richard@nod.at> writes:

> The Option GTM681W uses a qualcomm chip and can be
> served by the qcserial device driver.

Should it also be added to the qmi_wwan driver?


Bjørn
