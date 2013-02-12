Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759372Ab3BLVJ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 16:09:29 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:64722 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757688Ab3BLVJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 16:09:26 -0500
MIME-Version: 1.0
In-Reply-To: <CAPPqfY2hrd54viFHKErWk_8uRLHP9WK54G0inJtyUFJKKunDOg@mail.gmail.com>
References: <CAPPqfY1-sYT8rcPoJ6BD0axq=oczq+xbGFSQj=uth4wc_cvkGw@mail.gmail.com>
	<18379918.sbmR7uiKVn@vostro.rjw.lan>
	<CAPPqfY2umN2Fab=APyt4=LM32x2av7nPruADX3dddTxdWG2Umg@mail.gmail.com>
	<2048745.M7CAe2g1gj@vostro.rjw.lan>
	<CAPPqfY2hrd54viFHKErWk_8uRLHP9WK54G0inJtyUFJKKunDOg@mail.gmail.com>
Date: Tue, 12 Feb 2013 22:09:24 +0100
Message-ID: <CAPPqfY3+e3tVQA_RKn0DhwModLienrgtFzsUrCCsUndbJfnHOg@mail.gmail.com>
Subject: Re: Performance issue since 3.2.6
From: Olivier Doucet <webmaster@ajeux.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

A quick update on my latest tests :
I was able to compile a working 3.7.1 kernel (by 'working', I mean
with no performance penalty). I'm sure 3.7.7 will be OK also (do you
want me to test latest RC of 3.8 ?)

I had to disable CONFIG_ACPI_PROCESSOR to disable power management.
So now these two options are unset :
CONFIG_CPU_IDLE
CONFIG_ACPI_PROCESSOR

I've posted the whole .config file here :
https://gist.github.com/odoucet/4773390

I'll be glad to test any patch that may help reactivate PM on my
system (CPU Intel Xeon L5630)

Olivier
