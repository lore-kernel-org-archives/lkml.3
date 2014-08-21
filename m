Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211AbaHUW07 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 18:26:59 -0400
Received: from senator.holtmann.net ([87.106.208.187]:41845 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763AbaHUW06 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 18:26:58 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: Issue with clone() and CLONE_NEWUSER as unprivileged user
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <53F67057.4030202@amacapital.net>
Date: Thu, 21 Aug 2014 17:26:51 -0500
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Content-Transfer-Encoding: 7BIT
Message-Id: <A54DB26A-07AF-4DA8-899F-1DCE527C2389@holtmann.org>
References: <606D4327-C729-49F7-9CFD-3D25D0A62A13@holtmann.org> <53F67057.4030202@amacapital.net>
To: Andy Lutomirski <luto@amacapital.net>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

>> I am trying to use clone() and CLONE_NEWUSER for creating a new user namespace as an unprivileged user. I always get an operation not permitted error. However when I used fork() + unshare() as unprivileged user, I can create the new user namespace just fine.
>> 
>> Is there something obvious that I am missing? My understand is that CLONE_NEWUSER should not require any special capabilities. I tried the sample code from the manpage and also from LWN.net, but both give me the same error.
> 
> It works for me on 3.16 and 3.15 but not on 3.15.8-200.fc20.x86_64.  I'm
> a bit confused.  What kernel are you using?

I am running 3.15.6-200.fc20.x86_64 actually. What confused me is that fork() + unshare() works fine, but clone() doesn't.

Regards

Marcel

