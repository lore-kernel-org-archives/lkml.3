Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589AbbAPPhm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 10:37:42 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:51645 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563AbbAPPhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 10:37:41 -0500
MIME-Version: 1.0
In-Reply-To: <1421422253.8562.8.camel@x220>
References: <1421410284-23776-1-git-send-email-valentin.ilie@gmail.com>
 <1421420621.8562.1.camel@x220> <1421422253.8562.8.camel@x220>
From: Valentin Ilie <valentin.ilie@gmail.com>
Date: Fri, 16 Jan 2015 17:37:20 +0200
X-Google-Sender-Auth: Kfv3O2AWuy5IX7PFFSRdyTH2WJE
Message-ID: <CAHuBVBZtCvtfnRf7_ikLwTwYEyfy4G11GwU=4ns+XStO1GDVaQ@mail.gmail.com>
Subject: Re: [PATCH] mm/page_owner: Fix memory leak
To: Paul Bolle <pebolle@tiscali.nl>
Cc: iamjoonsoo.kim@lge.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 January 2015 at 17:30, Paul Bolle <pebolle@tiscali.nl> wrote:
> Before you resend: what happens to the resources of a userspace program
> when its main() returns?

On top of that, I should have used free, not kfree. I will resend v2 ..

Sorry for the mess

-- 
Valentin
