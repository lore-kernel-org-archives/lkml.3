Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060Ab3EVKhQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 06:37:16 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:36947 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484Ab3EVKhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 06:37:13 -0400
MIME-Version: 1.0
In-Reply-To: <519C9187.6040301@gmail.com>
References: <519B8021.6030002@gmail.com>
	<CANUX_P1sMR6ugSt1Q=hA4dLXQ=mo+dqbAoMi4dn46jYhZZzL7A@mail.gmail.com>
	<519C9187.6040301@gmail.com>
Date: Wed, 22 May 2013 13:37:11 +0300
Message-ID: <CANUX_P3A=EeuLhjDAbdsgrPVF0RVpjsg+ctbkvG+b5CTvhc99Q@mail.gmail.com>
Subject: Re: [v3.9.x stable regression, bisected] iwlwifi/iwldvm has a 30s
 delay in EAP authentication
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: kkhere.geo+suse@gmail.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>, gregkh@kroah.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>
>> Thanks for the bisection. Can you please try the patch in
>> https://bugzilla.kernel.org/show_bug.cgi?id=58341 and report?
>> Thanks
>>
>
> I can confirm that the patch in this bugzilla entry does indeed get
> rid of the delay in EAP authentication.
>

Thanks for the testing - patch on the way to upstream / stable
