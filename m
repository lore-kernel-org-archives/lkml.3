Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab3JUHNf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 03:13:35 -0400
Received: from mail-qe0-f44.google.com ([209.85.128.44]:48625 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584Ab3JUHNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 03:13:34 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpo=wHN1wTsh-UfYMO-XBDtj0=SFuxjTPqw9aZAG6iRJ0mQ@mail.gmail.com>
References: <6334c0aed4840857944d1b267871ada4d7014d57.1381541632.git.viresh.kumar@linaro.org>
	<1922770.iubCDBg3Zg@vostro.rjw.lan>
	<CAKohpokJkcsNN_vnQOuu2=arsiQCGPaCxpRL_TRAQYFg+LmR+w@mail.gmail.com>
	<1402816.XYNGOIhCWR@vostro.rjw.lan>
	<CAKohpo=wHN1wTsh-UfYMO-XBDtj0=SFuxjTPqw9aZAG6iRJ0mQ@mail.gmail.com>
Date: Mon, 21 Oct 2013 12:43:32 +0530
Message-ID: <CAKohpomXxodtUvGyo3SXRAVE8W9nZiYSU9Zak+zDt9+rOjonxw@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: acpi: Add comment under ACPI_ADR_SPACE_SYSTEM_IO case
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=047d7b5daca09a18b404e93b0578
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b5daca09a18b404e93b0578
Content-Type: text/plain; charset=ISO-8859-1

On 13 October 2013 06:07, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 13/10/2013, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> -> What about this:
>>
>>       /*
>>        * The core will not set policy->cur, because cpufreq_driver->get is NULL,
>>        * so we need to set it here.  However, we have to guess it, because the
>>        * current speed is unknown and not detectable via IO ports.
>>        */
>
> Far better. Attached again. Thanks.

Have you missed applying this one? Attached again..

--047d7b5daca09a18b404e93b0578
Content-Type: application/octet-stream; 
	name="0001-cpufreq-acpi-Add-comment-under-ACPI_ADR_SPACE_SYSTEM.patch"
Content-Disposition: attachment; 
	filename="0001-cpufreq-acpi-Add-comment-under-ACPI_ADR_SPACE_SYSTEM.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hn1db64x1

RnJvbSAwNTViNWQ3M2JlZjA4OThkNDc3MTg4MzcyYjIxNWNkMmVjODJmZTgxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpNZXNzYWdlLUlkOiA8MDU1YjVkNzNiZWYwODk4ZDQ3NzE4ODM3MmIyMTVj
ZDJlYzgyZmU4MS4xMzgxNjI0NjAyLmdpdC52aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRnJvbTog
VmlyZXNoIEt1bWFyIDx2aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRGF0ZTogU2F0LCAxMiBPY3Qg
MjAxMyAwNzowMDowMSArMDUzMApTdWJqZWN0OiBbUEFUQ0hdIGNwdWZyZXE6IGFjcGk6IEFkZCBj
b21tZW50IHVuZGVyIEFDUElfQURSX1NQQUNFX1NZU1RFTV9JTwogY2FzZQoKcG9saWN5LT5jdXIg
aXMgbm93IHNldCBieSBjcHVmcmVxIGNvcmUgd2hlbiBjcHVmcmVxX2RyaXZlci0+Z2V0KCkgaXMg
ZGVmaW5lZCBhbmQKc28gZHJpdmVycyBhcmVuJ3QgcmVxdWlyZWQgdG8gc2V0IGl0LiBXaGVuIHNw
YWNlX2lkIGlzIEFDUElfQURSX1NQQUNFX1NZU1RFTV9JTwpmb3IgYWNwaSBjcHVmcmVxIGRyaXZl
ciBpdCBkb2Vzbid0IHNldCAtPmdldCB0byBhIHZhbGlkIGZ1bmN0aW9uIHBvaW50ZXIgYW5kIHNv
CnBvbGljeS0+Y3VyIGlzIHJlcXVpcmVkIHRvIGJlIHNldCBieSBkcml2ZXIuCgpUaGlzIGlzIGFs
cmVhZHkgZm9sbG93ZWQgaW4gYWNwaS1jcHVmcmVxIGRyaXZlci4gVGhpcyBwYXRjaCBhZGRzIGEg
Y29tbWVudApkZXNjcmliaW5nIHdoeSB3ZSBuZWVkIHRvIHNldCBwb2xpY3ktPmN1ciBmcm9tIGRy
aXZlci4KClN1Z2dlc3RlZC1ieTogUmFmYWVsIEouIFd5c29ja2kgPHJhZmFlbC5qLnd5c29ja2lA
aW50ZWwuY29tPgpTaWduZWQtb2ZmLWJ5OiBWaXJlc2ggS3VtYXIgPHZpcmVzaC5rdW1hckBsaW5h
cm8ub3JnPgotLS0KIGRyaXZlcnMvY3B1ZnJlcS9hY3BpLWNwdWZyZXEuYyB8IDcgKysrKysrLQog
MSBmaWxlIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdp
dCBhL2RyaXZlcnMvY3B1ZnJlcS9hY3BpLWNwdWZyZXEuYyBiL2RyaXZlcnMvY3B1ZnJlcS9hY3Bp
LWNwdWZyZXEuYwppbmRleCBhOGRhYzdiLi5hMTcxN2Q3IDEwMDY0NAotLS0gYS9kcml2ZXJzL2Nw
dWZyZXEvYWNwaS1jcHVmcmVxLmMKKysrIGIvZHJpdmVycy9jcHVmcmVxL2FjcGktY3B1ZnJlcS5j
CkBAIC04MzcsNyArODM3LDEyIEBAIHN0YXRpYyBpbnQgYWNwaV9jcHVmcmVxX2NwdV9pbml0KHN0
cnVjdCBjcHVmcmVxX3BvbGljeSAqcG9saWN5KQogCiAJc3dpdGNoIChwZXJmLT5jb250cm9sX3Jl
Z2lzdGVyLnNwYWNlX2lkKSB7CiAJY2FzZSBBQ1BJX0FEUl9TUEFDRV9TWVNURU1fSU86Ci0JCS8q
IEN1cnJlbnQgc3BlZWQgaXMgdW5rbm93biBhbmQgbm90IGRldGVjdGFibGUgYnkgSU8gcG9ydCAq
LworCQkvKgorCQkgKiBUaGUgY29yZSB3aWxsIG5vdCBzZXQgcG9saWN5LT5jdXIsIGJlY2F1c2UK
KwkJICogY3B1ZnJlcV9kcml2ZXItPmdldCBpcyBOVUxMLCBzbyB3ZSBuZWVkIHRvIHNldCBpdCBo
ZXJlLgorCQkgKiBIb3dldmVyLCB3ZSBoYXZlIHRvIGd1ZXNzIGl0LCBiZWNhdXNlIHRoZSBjdXJy
ZW50IHNwZWVkIGlzCisJCSAqIHVua25vd24gYW5kIG5vdCBkZXRlY3RhYmxlIHZpYSBJTyBwb3J0
cy4KKwkJICovCiAJCXBvbGljeS0+Y3VyID0gYWNwaV9jcHVmcmVxX2d1ZXNzX2ZyZXEoZGF0YSwg
cG9saWN5LT5jcHUpOwogCQlicmVhazsKIAljYXNlIEFDUElfQURSX1NQQUNFX0ZJWEVEX0hBUkRX
QVJFOgotLSAKMS43LjEyLnJjMi4xOC5nNjFiNDcyZQoK
--047d7b5daca09a18b404e93b0578--
