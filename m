Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161713Ab3DEGwq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 02:52:46 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:60398 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161553Ab3DEGwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 02:52:45 -0400
MIME-Version: 1.0
Date: Thu, 4 Apr 2013 23:52:44 -0700
Message-ID: <CABhPDt_ky+AqmZ0cPGp4s8DWURFJk=w3A=CyU5GKBLTwWhVuZQ@mail.gmail.com>
Subject: Boot failure with EFI on a Lenovo x230 with 3.8.5
From: "Douglas, William" <william.douglas@intel.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

After upgrading to the latest stable kernel I found my x230 (with the
latest, v2.52 BIOS) no longer boots.

Using an EFI only boot scheme with gummiboot v29, I get a blank
backlit screen when attempting to boot up my distro. There isn't any
indication from the hard drive it has attempted any work and no
response from a netconsole so I'm at a loss for figuring out what
information I can provide.

I did take the time to bisect the commit causing my problem but it
seems to come from an unlikely looking place:

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=16fad69cfe4adbbfa813de516757b87bcae36d93

but after reverting that I am able to boot into my system normally.

Any suggestions on what I can do to get more information would be appreciated!


--
William
