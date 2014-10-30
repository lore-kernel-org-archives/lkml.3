Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758551AbaJ3IeX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 04:34:23 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:51749 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbaJ3IeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 04:34:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
        john.stultz@linaro.org, tj@kernel.org, marcel@holtmann.org,
        desrt@desrt.ca, hadess@hadess.net, dh.herrmann@gmail.com,
        tixxdz@opendz.org, simon.mcvittie@collabora.co.uk, daniel@zonque.org,
        alban.crequy@collabora.co.uk, javier.martinez@collabora.co.uk,
        teg@jklm.no
Subject: Re: [PATCH 00/12] Add kdbus implementation
Date: Thu, 30 Oct 2014 09:33:56 +0100
Message-ID: <4382138.U2ODUIQ55c@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Iumi68slk5E70UlzZtda4KR4aToCRBVZV5mGoxXkX8O
 7x4+42X8K2cq6lHahskE6/Pzu3BU+8RK0Cs1oYULXF0H6qUrdW
 EHD79+jzOAPbVmX/nXTkcb1Ez8EVdpt0fCf57CRDAPos8Jv7U5
 bl2kIfD5FJDb77Q28JVR138pfBI8fQ6Sj1CVh2a8+8qYr3XEVh
 cGlrr0KuRLftyvXsKp5HkdXRB4H1QwwfK1o2qIPBVfFMpo/dSn
 GnX3uuF7M0bu7kbXrPbqj23PQ0wkFOHyb2GH51sMRlhNBXIAi7
 injQg5/WlC/6kxSA8c1LLsTMLpOwng8P5mEu3pESTfqmWkHXtT
 Jaxgw6+cXUjzGxbPBccU=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 October 2014 15:00:44 Greg Kroah-Hartman wrote:
>  drivers/misc/Kconfig                             |    1 +
>  drivers/misc/Makefile                            |    1 +
>  drivers/misc/kdbus/Kconfig                       |   11 +
>  drivers/misc/kdbus/Makefile                      |   19 +
>  drivers/misc/kdbus/bus.c                         |  450 ++++++
>  drivers/misc/kdbus/bus.h                         |  107 ++
>  drivers/misc/kdbus/connection.c                  | 1751 +++++++++++++++++++++
>  drivers/misc/kdbus/connection.h                  |  177 +++
>  drivers/misc/kdbus/domain.c                      |  477 ++++++
> 

One very high-level common:

Since this is going to be a very commonly used IPC mechanism, I don't
like the idea of stuffing it into drivers/misc.

How about putting it into drivers/kdbus or ipc/kdbus instead?

	Arnd
