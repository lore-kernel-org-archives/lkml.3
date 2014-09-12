Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177AbaILWcP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 18:32:15 -0400
Received: from mout.web.de ([212.227.17.12]:65396 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056AbaILWcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 18:32:14 -0400
From: Martin Walch <walch.martin@web.de>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: kconfig: NEW: syntax highlighting for Kconfig files in KDE
Date: Sat, 13 Sep 2014 00:32:09 +0200
Message-ID: <27129446.btpinNW7pO@tacticalops>
User-Agent: KMail/4.14 (Linux/3.15.10-gentoo-gnu; KDE/4.14.0; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:wS7IZ4swHH/uP3FL9Xp/SE/rScDFMM03UpUnAOfSvntL6fvQomr
 GM118GiJE9J1b05ecL7sgUWpbguL0bWVShOj5cQ6fIEGFqZiB4wMI3gzab8276DTg2wu1UP
 JfIsKvyWyJ0twwmANGcK0KckReDVUQ2NDEi8L17Dxo09jF22xEvK131KBUz+mE2iCic0QbS
 EhXIvT5Wz/g2DVxR4s9+A==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The text editors in KDE (Kate, KWrite, KDevelop, etc.) now support
highlighting Kconfig files. This will ship with KDE SC 4.14.1, older versions
back to KDE 4.4.0 can easily get it by running Kate and using the download
dialog at >Settings >Configure Kate... >Editor Component: Open/Save
>Modes & Filetypes >Download Highlighting Files...

Kate automatically applies this highlighting style to all files with names
that start with "Kconfig" unless some other pattern applies (e.g. *.c).

The highlighting should be pretty accurate with the usual formatting
scheme that most syntax highlighters of KDE apply and it comes with code
folding support and spell checking. However, it still lacks an indenter.
It also has no other fancy stuff like accurate auto-completion or jumping
to a declaration.

While the infrastructure of Kate Part primarily targets highlighting
syntactically valid files (not caring about invalid syntax), this highlighter
also underlines anything that will lead to a syntax error when running *conf.
Bad characters that do not lead up to a syntax error, but which will be
silently ignored, are red with a light red background.

This all comes at the cost of rather high cpu usage. You may notice when
loading large files, depending on your hardware. Also, automatic spell
checking on large files may slow things down. If you intend to open hundreds
of Kconfig files at once, expect it to take a long time.

Please report bugs either to me via email (subject start [kconfig.xml]) or
in the bug tracker of KDE at https://bugs.kde.org/

Regards
Martin Walch
-- 

