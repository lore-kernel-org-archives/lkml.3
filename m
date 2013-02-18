Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab3BRL5I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 06:57:08 -0500
Received: from chrocht.moloch.sk ([62.176.169.44]:38245 "EHLO mail.moloch.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218Ab3BRL5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 06:57:07 -0500
Message-ID: <51221710.5060102@250bpm.com>
Date: Mon, 18 Feb 2013 12:57:04 +0100
From: Martin Sustrik <sustrik@250bpm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111109 Thunderbird/3.1.16
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Alexander Viro <viro@zeniv.linux.org.uk>,
        Sha Zhengju <handai.szj@taobao.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Davide Libenzi <davidel@xmailserver.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Eric Wong <normalperson@yhbt.net>
Subject: Re: [PATCH v2 1/1] eventfd: implementation of EFD_MASK flag
References: <1360311077-14474-1-git-send-email-sustrik@250bpm.com> <20130214145430.04f8750c.akpm@linux-foundation.org>
In-Reply-To: <20130214145430.04f8750c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/02/13 23:54, Andrew Morton wrote:

> This patch adds userspace interfaces which will require manpage
> updates.  Please Cc Michael and work with him on getting those changes
> completed.

Right. It adds the efd_mask structure. As far as I understand how it 
works is that the actual user-space definition of the structure should 
be provided by glibc (sys/eventfd.h), right?

If so, should the man page be updated now? If so, it may result in the 
situation where the man page describes a structure that's not available 
in the user space yet.

Is there a formal process to do this kind of kernel+glibc+docs changes?

Martin
