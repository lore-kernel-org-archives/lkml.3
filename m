Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbaFBPC5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 11:02:57 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:41962 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755244AbaFBPC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 11:02:56 -0400
MIME-Version: 1.0
In-Reply-To: <20140529081928.4CDCB1463DC2@linuxdev-32>
References: <20140529081928.4CDCB1463DC2@linuxdev-32>
Date: Mon, 2 Jun 2014 08:02:55 -0700
X-Google-Sender-Auth: Ay2rIxucb6OIcxtUpwDWin1jkDg
Message-ID: <CA+55aFwj+hPCv4rzNpPDtpGzh4bfOUu3QyGOhv5wGO5zaLJpcQ@mail.gmail.com>
Subject: Re: [GIT PULL REQUEST] UniCore32 update for 3.15-rc7
From: Linus Torvalds <torvalds@linux-foundation.org>
To: guanxuetao <guanxuetao@mprc.pku.edu.cn>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 1:19 AM, guanxuetao <guanxuetao@mprc.pku.edu.cn> wrote:
>
>   git://github.com/gxt/linux.git unicore32

Guan, this isn't the usual signed tag I see from you, and when it
comes from a public hosting place like github, I _really_ want to see
the stuff I pull being signed. I realize that the email itself has a
gpg signature, but since there are no sane ways to actually verify
email signatures (or save them in git if you were to use one of the
baroque few email clients that do), that doesn't exactly help..

             Linus
