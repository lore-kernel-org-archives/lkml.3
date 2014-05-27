Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932070AbaE0Tsl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 15:48:41 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:34654 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410AbaE0Tsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 15:48:40 -0400
MIME-Version: 1.0
In-Reply-To: <1401219641-79301-1-git-send-email-eric.ernst@linux.intel.com>
References: <1401219641-79301-1-git-send-email-eric.ernst@linux.intel.com>
Date: Tue, 27 May 2014 15:48:40 -0400
X-Google-Sender-Auth: Meo5UE12m4ung1orKalV8RzrT2Q
Message-ID: <CA+5PVA5pBb1C7bQE2Od+jamEGr3=hepT-6OVsQFE7GZvU=2_yA@mail.gmail.com>
Subject: Re: [PATCH 1/1] Add kernel parameter for kernel version
From: Josh Boyer <jwboyer@fedoraproject.org>
To: eric.ernst@linux.intel.com
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        mark.gross@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 3:40 PM,  <eric.ernst@linux.intel.com> wrote:
> From: Eric Ernst <eric.ernst@linux.intel.com>
>
> Create a kernel cmdline parameter, "version_addendum", which can be
> used to add text to the kernel version that is reported from
> /proc/version.

Why?

What is the intended purpose of this and why would someone want to use it?

josh
