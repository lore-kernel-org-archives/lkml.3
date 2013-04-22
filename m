Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065Ab3DVMU6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 08:20:58 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:48842 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752365Ab3DVMU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 08:20:56 -0400
Message-ID: <51752B25.9020809@console-pimps.org>
Date: Mon, 22 Apr 2013 13:20:53 +0100
From: Matt Fleming <matt@console-pimps.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: joeyli <jlee@suse.com>
CC: Jiri Slaby <jslaby@suse.cz>, matthew.garrett@nebula.com,
        cbouatmailru@gmail.com, ccross@android.com, keescook@chromium.org,
        Tony Luck <tony.luck@intel.com>, linux-efi@vger.kernel.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Cannot add new efi boot entry
References: <516B1ED3.9040900@suse.cz>  <1366106168.23707.9.camel@linux-s257.site> <516D23B5.4070209@intel.com>  <516EB1B6.7050506@suse.cz> <516EB6F2.6070806@console-pimps.org>  <51703664.40003@suse.cz> <5172466B.9080105@suse.cz>  <517519E3.2030409@console-pimps.org> <1366630277.23707.132.camel@linux-s257.site>
In-Reply-To: <1366630277.23707.132.camel@linux-s257.site>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/04/13 12:31, joeyli wrote:
> Does garbage collection only trigger by UEFI BIOS when system reboot? or
> garbage collection also triggered at run time?

That is implementation specific. AFAIK, there are implementations for
both schemes.

-- 
Matt Fleming, Intel Open Source Technology Center
