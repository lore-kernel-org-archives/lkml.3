Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728AbbATSvX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 13:51:23 -0500
Received: from zill.ext.symas.net ([69.43.206.106]:46866 "EHLO
	zill.ext.symas.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596AbbATSvV (ORCPT
	<rfc822;Linux-Kernel@Vger.Kernel.ORG>);
	Tue, 20 Jan 2015 13:51:21 -0500
Message-ID: <54BEA3A3.9000407@symas.com>
Date: Tue, 20 Jan 2015 18:51:15 +0000
From: Howard Chu <hyc@symas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:37.0) Gecko/20100101 Firefox/37.0 SeaMonkey/2.34a1
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Jiri Slaby <jslaby@suse.cz>,
        Linux Kernel Mailing List <Linux-Kernel@vger.kernel.org>,
        linux-serial@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] n_tty: Remove LINEMODE support
References: <1421616632-4077-1-git-send-email-peter@hurleysoftware.com> <54BC3771.7030204@symas.com> <54BC5EC7.1090202@hurleysoftware.com> <54BCFC94.1040605@symas.com> <54BD1B53.9030901@hurleysoftware.com> <54BD328F.9090208@symas.com> <54BD567C.8070200@hurleysoftware.com> <54BD5E54.3050909@symas.com> <54BE9840.8080808@hurleysoftware.com> <54BEA0E0.9080807@symas.com>
In-Reply-To: <54BEA0E0.9080807@symas.com>
Content-Type: multipart/mixed;
 boundary="------------020302060800040504050302"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020302060800040504050302
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Howard Chu wrote:
> Peter Hurley wrote:
>> On 01/19/2015 02:43 PM, Howard Chu wrote:
>>> The fact that EXTPROC can be manually unset is by design. Quoting
>>> from the original again:
>>>
>>>> stty.diff:
>>>>      This file contains the changes needed for the stty(1) program
>>>>      to report on the current status of the TS_EXTPROC bit.  It also
>>>>      allows the user to turn on/off the TS_EXTPROC bit.  This is useful
>>>>      because it allows the user to say "stty -extproc", and the
>>>>      LINEMODE option will be automatically disabled, and saying "stty
>>>>      extproc" will re-enable the LINEMODE option.
>>
>> This option is not supported by gnu coreutils.
>
> OK. It's in *BSD and Minix. Looks like I never wrote a patch for
> coreutils for this last time around.

Wrote it, just never submitted it.

-- 
   -- Howard Chu
   CTO, Symas Corp.           http://www.symas.com
   Director, Highland Sun     http://highlandsun.com/hyc/
   Chief Architect, OpenLDAP  http://www.openldap.org/project/

--------------020302060800040504050302
Content-Type: text/plain; charset=UTF-8;
 name="dif.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="dif.txt"

LS0tIHN0dHkuYwkyMDA5LTA0LTI0IDEzOjQxOjE5LjAwMDAwMDAwMCArMDEwMAorKysgLi4v
Li4vLi4vY29yZXV0aWxzLTcuNC9zcmMvc3R0eS5jCTIwMTAtMDYtMTcgMDY6NDg6NDIuMDAw
MDAwMDAwICswMTAwCkBAIC0zMzAsNiArMzMwLDkgQEAKICAgeyJlY2hva2UiLCBsb2NhbCwg
U0FORV9TRVQgfCBSRVYsIEVDSE9LRSwgMH0sCiAgIHsiY3J0a2lsbCIsIGxvY2FsLCBSRVYg
fCBPTUlULCBFQ0hPS0UsIDB9LAogI2VuZGlmCisjaWZkZWYgRVhUUFJPQworICB7ImV4dHBy
b2MiLCBsb2NhbCwgU0FORV9VTlNFVCB8IFJFViwgRVhUUFJPQywgMH0sCisjZW5kaWYKIAog
ICB7ImV2ZW5wIiwgY29tYmluYXRpb24sIFJFViB8IE9NSVQsIDAsIDB9LAogICB7InBhcml0
eSIsIGNvbWJpbmF0aW9uLCBSRVYgfCBPTUlULCAwLCAwfSwK
--------------020302060800040504050302--
