Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460Ab3FZF2y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 01:28:54 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:46561 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab3FZF2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 01:28:52 -0400
Message-ID: <51CA7C12.6070400@free-electrons.com>
Date: Wed, 26 Jun 2013 07:28:50 +0200
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Workaround: kernel Docbook documentation - fsfunc prefix issue
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We're maintaining an online copy of kernel documentation at
http://free-electrons.com/kerneldoc/, where Docbook .tmpl files have
been converted to html, using the "make htmldocs" command. The goal is
to make such automatically generated documentation available to search
engines.

I noticed that in the generated .html files, all function names where
prefixed by "fsfunc", which was quite ugly.

At least in Debian based distros, this is actually a known bug in the
"docbook-xls" package:
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=654338

Fortunately, a fix is now available. You can either upgrade to the
latest Debian versions, or just install the new package manually. That's
what I did on my Ubuntu 13.04 system:
> wget
http://ftp.us.debian.org/debian/pool/main/d/docbook-xsl/docbook-xsl_1.78.1+dfsg-1_all.deb
> sudo dpkg -i docbook-xsl_1.78.1+dfsg-1_all.deb

Now, my generated kernel documentation looks great again.

Cheers,

Michael.

-- 
Michael Opdenacker, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
+33 484 258 098

