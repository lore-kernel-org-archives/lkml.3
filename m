Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815Ab3FNWcW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 18:32:22 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:36029 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652Ab3FNWcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 18:32:20 -0400
Message-ID: <51BB99F0.6030607@gmail.com>
Date: Fri, 14 Jun 2013 17:32:16 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tony Luck <tony.luck@gmail.com>
CC: Kees Cook <keescook@chromium.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Colin Cross <ccross@android.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] pstore/ram for 3.11
References: <51B9402C.5070300@gmail.com> <CA+8MBbKPr_y4rTBArcmz315y0f2-07Qu6DsM2cj-XW7-U=L56Q@mail.gmail.com>
In-Reply-To: <CA+8MBbKPr_y4rTBArcmz315y0f2-07Qu6DsM2cj-XW7-U=L56Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2013 05:18 PM, Tony Luck wrote:
> On Wed, Jun 12, 2013 at 8:44 PM, Rob Herring <robherring2@gmail.com> wrote:
>> Not sure who takes this, but please pull these 2 changes for pstore for
>> 3.11. These are necessary to get pstore to work with on-chip RAM on
>> Calxeda highbank platform.
> 
> Were these posted for discussion and review?  Is there anyone who should
> be providing {Acked,Reviewed,Tested}-by: tags for them?  I haven't ever had
> a sub-maintained tree to pull from - so I'm being double-extra cautious before
> doing something with this as it all feels new and strange.

Yes, here:

https://lkml.org/lkml/2013/4/9/831

The main discussion was around the write-combining change which I
dropped. You can pick patches 2 and 3 off the mail list if you prefer. I
would assume they only require an ack from one of the 4 of you which
pulling the tree implicitly does.

Rob
