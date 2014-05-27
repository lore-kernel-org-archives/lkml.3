Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397AbaE0VRG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 17:17:06 -0400
Received: from mail-yh0-f48.google.com ([209.85.213.48]:42712 "EHLO
	mail-yh0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886AbaE0VRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 17:17:04 -0400
MIME-Version: 1.0
X-Originating-IP: [128.107.151.95]
In-Reply-To: <20140527203956.GO15585@mwanda>
References: <1401221390-10655-1-git-send-email-c@24.io>
	<20140527203956.GO15585@mwanda>
Date: Tue, 27 May 2014 14:17:03 -0700
Message-ID: <CADadk9FADPTDfuwKX2_Bq1gTFnq-pPRYS1CxwyuZRFwcGcrjyQ@mail.gmail.com>
Subject: Re: [PATCH 1/6] Staging: rtl8192u: r8180_93cx6.c & r8192U_wx.c fix
 checkpatch.pl errors and warnings
From: Chaitanya Hazarey <c@24.io>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrea Merello <andrea.merello@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Ksenia Ragiadakou <burzalodowa@gmail.com>,
        devel <devel@driverdev.osuosl.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, it is what it is, will send the patch the right way.

Best,

Chaitanya

On Tue, May 27, 2014 at 1:39 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Tue, May 27, 2014 at 01:09:45PM -0700, Chaitanya Hazarey wrote:
>> Fixed the following:
>>
>> ERROR: do not use C99 // comments
>> ERROR: space required after that ',' (ctx:VxV)
>> ERROR: space required after that ';' (ctx:VxV)
>> ERROR: space required before the open brace '{'
>> ERROR: spaces required around that '=' (ctx:VxV)
>> ERROR: spaces required around that '<' (ctx:VxV)
>> ERROR: space required after that close brace '}'
>> ERROR: spaces required around that '==' (ctx:VxV)
>> ERROR: space required before the open parenthesis '('
>>
>
> All of these patches have the same subject.  And also they aren't
> broken up in the correct way.  Basically for this kind of thing we want
> to see one kind of cleanup per patch.
>
> [patch 1/6] Staging: rtl8192u: add missing spaces
> [patch 2/6] Staging: rtl8192u: delete commented out code
> [patch 3/6] Staging: rtl8192u: clean up c99 comments
> [patch 4/6] Staging: rtl8192u: reformat long lines
> ...
>
> Etc.
>
> Sorry for asking people to redo these again...
>
> regards,
> dan carpenter
>
