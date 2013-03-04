Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758214Ab3CDOoK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 09:44:10 -0500
Received: from smtp2.infineon.com ([217.10.60.23]:9617 "EHLO
	smtp2.infineon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758011Ab3CDOoJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 09:44:09 -0500
X-SBRS: None
From: <Peter.Huewe@infineon.com>
To: <key@linux.vnet.ibm.com>, <PeterHuewe@gmx.de>
CC: <khali@linux-fr.org>, <tpmdd-devel@lists.sourceforge.net>,
        <akpm@linux-foundation.org>, <shpedoikal@gmail.com>,
        <linux-kernel@vger.kernel.org>
Subject: RE: [tpmdd-devel] [PATCH RESEND] char/tpm: Convert struct i2c_msg
 initialization to C99 format
Thread-Topic: [tpmdd-devel] [PATCH RESEND] char/tpm: Convert struct i2c_msg
 initialization to C99 format
Thread-Index: AQHOFiY7nO+Fcn7PdEGcXhxDBxh6p5iVoKtg
Date: Mon, 4 Mar 2013 14:44:05 +0000
Message-ID: <74A44E99E3274B4CB570415926B37D4413B88D@MUCSE501.eu.infineon.com>
References: <20130228110611.3ed77e92@endymion.delvare>
	<20130228233235.5f279117@endymion.delvare>
	<CAM0nabENksjYahD49cx_GnnxN6XbEROo7zgyqP8s33zhcZUYYg@mail.gmail.com>
	<201302282358.38102.PeterHuewe@gmx.de>
 <20130228230712.GA17686@ennui.austin.ibm.com>
In-Reply-To: <20130228230712.GA17686@ennui.austin.ibm.com>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.23.8.248]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Yes, no problem.
>> I'll create a patch without it -
>> I'll make it this way that you can apply the conversion patch first 
>> and then the change.

>Thanks!
>Kent

The new version of my patch was just sent - please apply this one first.

Thanks,
Peter





-----------------------------------------------
Peter Huewe
Dipl. Inf. (FH)

Infineon Technologies AG 
CCS TI SWT SW ESW
Tel: 	+49 821 25851-86
Fax: 	+49 821 25851-40

Peter.Huewe@infineon.com

****VISIT US AT: www.infineon.com *****
Infineon Technologies AG 
Vorsitzender des Aufsichtsrats: Wolfgang Mayrhuber
Vorstand: Dr. Reinhard Ploss (Vorsitzender), Dominik Asam, Arunjai Mittal
Sitz der Gesellschaft: Neubiberg 
Registergericht: München HRB 126492 
 
