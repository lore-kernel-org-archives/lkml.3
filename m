Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715AbaCPAae (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 20:30:34 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:48251 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756590AbaCPAad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 20:30:33 -0400
Date: Sat, 15 Mar 2014 17:30:31 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Valdis.Kletnieks@vt.edu
cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: next-20140312 - build error in drivers/acpi/sleep.c
In-Reply-To: <72679.1394830609@turing-police.cc.vt.edu>
Message-ID: <alpine.DEB.2.02.1403151730060.29566@chino.kir.corp.google.com>
References: <22429.1394736511@turing-police.cc.vt.edu> <1431943.FB4azhDoEG@vostro.rjw.lan> <72679.1394830609@turing-police.cc.vt.edu>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Mar 2014, Valdis.Kletnieks@vt.edu wrote:

> This appears to be fixed in next-20140314, with updated commit:
> 

Yes, I can no longer trigger the build errors, thanks!
