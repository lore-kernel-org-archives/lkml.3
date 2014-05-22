Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184AbaEVQ6D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 12:58:03 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:37230 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbaEVQ6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 12:58:00 -0400
MIME-Version: 1.0
In-Reply-To: <537D6A6B.4090700@intel.com>
References: <537D6A6B.4090700@intel.com>
Date: Thu, 22 May 2014 09:57:59 -0700
X-Google-Sender-Auth: 5npGzDm5dpkicHTj-N9pAnArDXI
Message-ID: <CAGXu5j+MjFrzdehfLyOjkLTZb68nOMR8exg8eFHis_px-qD17Q@mail.gmail.com>
Subject: Re: [LSM] Kernel panic - not syncing: Could not register MntRestrict
 security module
From: Kees Cook <keescook@chromium.org>
To: Jet Chen <jet.chen@intel.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 8:09 PM, Jet Chen <jet.chen@intel.com> wrote:
> [    0.020000] Security Framework initialized
> [    0.020000] AppArmor: AppArmor initialized
> [    0.020000] Kernel panic - not syncing: Could not register MntRestrict
> security module

This was originally "by design", but I've changed it to check for
other LSMs being initialized before it now.

Thanks!

-Kees

-- 
Kees Cook
Chrome OS Security
