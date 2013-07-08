Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab3GHWQf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 18:16:35 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:60445 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298Ab3GHWQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 18:16:34 -0400
MIME-Version: 1.0
In-Reply-To: <51DB20CB.9020706@nod.at>
References: <51DB1EE5.5040108@google.com> <51DB20CB.9020706@nod.at>
From: Tristan Schmelcher <tschmelcher@google.com>
Date: Mon, 8 Jul 2013 18:16:06 -0400
Message-ID: <CADNZ+wTyryruLzaTDzw=502iLJwQ-wA_Rr5P_KJemRCFqXZxMg@mail.gmail.com>
Subject: Re: [PATCHv3] uml: Fix which_tmpdir failure when /dev/shm is a
 symlink, and in other edge cases
To: Richard Weinberger <richard@nod.at>
Cc: jdike@addtoit.com,
        user-mode-linux-devel <user-mode-linux-devel@lists.sourceforge.net>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 July 2013 16:27, Richard Weinberger <richard@nod.at> wrote:
> Is this just a resend or did your alter the patch you sent me already?
> I'm about to send my UML patches to Linus tomorrow.

Just a re-send. I thought I was supposed to re-send linux-next patches
after the merge window opens. Sorry if that wasn't right--I'm new at
this. :)
