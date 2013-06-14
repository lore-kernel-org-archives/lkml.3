Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414Ab3FNWSl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 18:18:41 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:57411 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537Ab3FNWSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 18:18:40 -0400
MIME-Version: 1.0
In-Reply-To: <51B9402C.5070300@gmail.com>
References: <51B9402C.5070300@gmail.com>
Date: Fri, 14 Jun 2013 15:18:39 -0700
Message-ID: <CA+8MBbKPr_y4rTBArcmz315y0f2-07Qu6DsM2cj-XW7-U=L56Q@mail.gmail.com>
Subject: Re: [GIT PULL] pstore/ram for 3.11
From: Tony Luck <tony.luck@gmail.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Kees Cook <keescook@chromium.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Colin Cross <ccross@android.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 8:44 PM, Rob Herring <robherring2@gmail.com> wrote:
> Not sure who takes this, but please pull these 2 changes for pstore for
> 3.11. These are necessary to get pstore to work with on-chip RAM on
> Calxeda highbank platform.

Were these posted for discussion and review?  Is there anyone who should
be providing {Acked,Reviewed,Tested}-by: tags for them?  I haven't ever had
a sub-maintained tree to pull from - so I'm being double-extra cautious before
doing something with this as it all feels new and strange.

-Tony
