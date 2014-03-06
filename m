Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313AbaCFRvw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 12:51:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3074 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753087AbaCFRvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 12:51:50 -0500
From: Igor Mammedov <imammedo@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, andi@firstfloor.org
Subject: Re: [PATCH] x86: Plug racy xAPIC access of CPU hotplug code
Date: Thu,  6 Mar 2014 18:51:11 +0100
Message-Id: <1394128271-31500-1-git-send-email-imammedo@redhat.com>
In-Reply-To: <52E6AFFE.3030004@siemens.com>
References: <52E6AFFE.3030004@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Patch fixes bug https://bugzilla.redhat.com/show_bug.cgi?id=1073568
Before it was possible to hang guest in several minutes,
now reproducer runs for several hours without any issue.
So,

Tested-By: Igor Mammedov <imammedo@redhat.com>

