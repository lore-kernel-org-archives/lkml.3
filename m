Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847Ab3KKION (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 03:14:13 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:42818 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614Ab3KKIOJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 03:14:09 -0500
Date: Mon, 11 Nov 2013 02:14:06 -0600
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH] Adding Documentation/module-signing.txt file
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Josh Boyer <jwboyer@fedoraproject.org>,
        James Solner <solner@alcatel-lucent.com>,
        David Howells <dhowells@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
References: <14578957.OSuohDRLT9@cmlinux10.ih.lucent.com>
	<CA+5PVA4C_KN=aUPewU+xHa4PSogskYMPugi-wBAZ=Ft446vDbg@mail.gmail.com>
	<1383692092.1974.249@driftwood> <5279B82E.7000600@infradead.org>
In-Reply-To: <5279B82E.7000600@infradead.org> (from rdunlap@infradead.org on
	Tue Nov  5 21:31:58 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1384157646.1974.265@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2013 09:31:58 PM, Randy Dunlap wrote:
> On 11/05/13 14:54, Rob Landley wrote:
> > On 10/24/2013 07:08:33 PM, Josh Boyer wrote:
> >> On Thu, Oct 24, 2013 at 6:35 PM, James Solner  
> <solner@alcatel-lucent.com> wrote:
> >> > This patch adds the Documentation/module-signing.txt file that is
> >> > missing. There is a link to Documentation/module-signing.txt file
> >> > in init/Kconfig that references this file.
> >> >
> >> > Signed-off-by: James Solner <solner@alcatel-lucent.com>
> >>
> >> Nak.  Please see below.
...
> There was a new version posted earlier today:
> http://marc.info/?l=linux-kernel&m=138369435917393&w=2
> 
> 
> It still needs to be cleaned up IMO.

Is there any place other than the top level Documentation directory to  
put it? (Start a modules subdirectory, maybe?)

Rob