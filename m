Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408AbaHUWTJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 18:19:09 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:49405 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754975AbaHUWTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 18:19:07 -0400
Message-ID: <53F67057.4030202@amacapital.net>
Date: Thu, 21 Aug 2014 15:19:03 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Marcel Holtmann <marcel@holtmann.org>, LKML <linux-kernel@vger.kernel.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: Issue with clone() and CLONE_NEWUSER as unprivileged user
References: <606D4327-C729-49F7-9CFD-3D25D0A62A13@holtmann.org>
In-Reply-To: <606D4327-C729-49F7-9CFD-3D25D0A62A13@holtmann.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2014 10:35 PM, Marcel Holtmann wrote:
> Hi,
> 
> I am trying to use clone() and CLONE_NEWUSER for creating a new user namespace as an unprivileged user. I always get an operation not permitted error. However when I used fork() + unshare() as unprivileged user, I can create the new user namespace just fine.
> 
> Is there something obvious that I am missing? My understand is that CLONE_NEWUSER should not require any special capabilities. I tried the sample code from the manpage and also from LWN.net, but both give me the same error.

It works for me on 3.16 and 3.15 but not on 3.15.8-200.fc20.x86_64.  I'm
a bit confused.  What kernel are you using?

--Andy

> 
> Regards
> 
> Marcel
> 

