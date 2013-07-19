Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760770Ab3GSPVR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 11:21:17 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:55677 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760724Ab3GSPVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 11:21:16 -0400
MIME-Version: 1.0
In-Reply-To: <CAPhGq=b6_7=i3e=9gkT9s5JZ+hAPcu8T_S+M9Yt60nt3vA6Nrw@mail.gmail.com>
References: <1374245148-24031-1-git-send-email-alexj@rosedu.org>
	<CAOJsxLGEmjY6wTp99DKQ4ZKO2oXq6102MczbjCHTUReuCTq-fw@mail.gmail.com>
	<CAPhGq=b6_7=i3e=9gkT9s5JZ+hAPcu8T_S+M9Yt60nt3vA6Nrw@mail.gmail.com>
Date: Fri, 19 Jul 2013 18:21:15 +0300
X-Google-Sender-Auth: Mh4xXNHib7BJZ56VT--Uaq-NQIY
Message-ID: <CAOJsxLFw4t-jwO4vDuMYfZA4uqH59h1c66xVPPFDO037OvGKSg@mail.gmail.com>
Subject: Re: [PATCH] lustre:libcfs: remove redundant code.
From: Pekka Enberg <penberg@kernel.org>
To: Alexandru Juncu <alexj@rosedu.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, andreas.dilger@intel.com,
        tao.peng@emc.com, driverdev <devel@driverdev.osuosl.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 6:13 PM, Alexandru Juncu <alexj@rosedu.org> wrote:
> I was thinking the same thing, but I hesitated because I didn't know
> how used it was and I didn't want to break something.

"git grep cfs_strdup" suggests that nobody uses it so you could just
remove it completely...
