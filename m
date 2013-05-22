Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659Ab3EVJgQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 05:36:16 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:40987 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755138Ab3EVJgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 05:36:10 -0400
Message-ID: <519C9187.6040301@gmail.com>
Date: Wed, 22 May 2013 11:36:07 +0200
From: Kshitij Kulshreshtha <kkhere.geo@gmail.com>
Reply-To: kkhere.geo+suse@gmail.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Emmanuel Grumbach <egrumbach@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>, gregkh@kroah.com
Subject: Re: [v3.9.x stable regression, bisected] iwlwifi/iwldvm has a 30s
 delay in EAP authentication
References: <519B8021.6030002@gmail.com> <CANUX_P1sMR6ugSt1Q=hA4dLXQ=mo+dqbAoMi4dn46jYhZZzL7A@mail.gmail.com>
In-Reply-To: <CANUX_P1sMR6ugSt1Q=hA4dLXQ=mo+dqbAoMi4dn46jYhZZzL7A@mail.gmail.com>
X-Enigmail-Version: 1.6a1pre
OpenPGP: id=B98DF0DF
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As on 2013-05-22 10:17h, Emmanuel Grumbach did write:
> 
> Thanks for the bisection. Can you please try the patch in 
> https://bugzilla.kernel.org/show_bug.cgi?id=58341 and report? 
> Thanks
> 

I can confirm that the patch in this bugzilla entry does indeed get
rid of the delay in EAP authentication.

Thanks.
Kshitij

-- 
Dr. Kshitij Kulshreshtha

Institut für Mathematik,
Universität Paderborn,
Warburger Straße 100,
33098 Paderborn.

Büro: A3.235

Privatanschrift:
Arnikaweg 62
33100 Paderborn.
