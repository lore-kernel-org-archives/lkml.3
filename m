Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab3DVMZI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 08:25:08 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:64689 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178Ab3DVMZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 08:25:06 -0400
Message-ID: <51752C2C.4090707@suse.cz>
Date: Mon, 22 Apr 2013 14:25:16 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>, joeyli <jlee@suse.com>
CC: matthew.garrett@nebula.com, cbouatmailru@gmail.com, ccross@android.com,
        keescook@chromium.org, Tony Luck <tony.luck@intel.com>,
        linux-efi@vger.kernel.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Cannot add new efi boot entry
References: <516B1ED3.9040900@suse.cz>  <1366106168.23707.9.camel@linux-s257.site> <516D23B5.4070209@intel.com>  <516EB1B6.7050506@suse.cz> <516EB6F2.6070806@console-pimps.org>  <51703664.40003@suse.cz> <5172466B.9080105@suse.cz>  <517519E3.2030409@console-pimps.org> <1366630277.23707.132.camel@linux-s257.site> <51752B25.9020809@console-pimps.org>
In-Reply-To: <51752B25.9020809@console-pimps.org>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2013 02:20 PM, Matt Fleming wrote:
> On 22/04/13 12:31, joeyli wrote:
>> Does garbage collection only trigger by UEFI BIOS when system reboot? or
>> garbage collection also triggered at run time?
> 
> That is implementation specific. AFAIK, there are implementations for
> both schemes.

Just a point from the abstract level. Is there a way to find out? And
what do Windows do?

thanks,
-- 
js
suse labs
