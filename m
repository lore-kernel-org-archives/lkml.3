Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965071Ab3DKQzn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 12:55:43 -0400
Received: from mx2.parallels.com ([199.115.105.18]:33648 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964928Ab3DKQzl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 12:55:41 -0400
From: James Bottomley <jbottomley@parallels.com>
To: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: license of string_helpers module
Thread-Topic: license of string_helpers module
Thread-Index: AQHONtOzTrULgl8vtkeNIKnLexnWxZjRsnuA
Date: Thu, 11 Apr 2013 16:55:40 +0000
Message-ID: <1365699339.1927.45.camel@dabdike>
References: <1365698594.28859.1.camel@smile>
In-Reply-To: <1365698594.28859.1.camel@smile>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [24.18.112.117]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <B9C096267A7E58418C2C4EE7CE13BF99@sw.swsoft.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-04-11 at 16:43 +0000, Shevchenko, Andriy wrote:
> Hello, James.
> 
> Could you please share what is the License applied to the
> lib/string_helpers.c module which you wrote on 2008?

Um, it's in the kernel, so it follows the licence of the COPYING file,
so GPLv2 only.

> Shall we update top of the file to be clear on it in future?

There's no need to waste space with individual licences, that's why we
have a COPYING file.

James

