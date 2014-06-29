Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605AbaF2HTO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 03:19:14 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:41907 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487AbaF2HTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 03:19:11 -0400
MIME-Version: 1.0
In-Reply-To: <CANeU7QnLad1f4KkLpTGSWB8eD8_La-tACim6rR7DLQ=hggwhOQ@mail.gmail.com>
References: <1402996306-6811-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1402996306-6811-3-git-send-email-andriy.shevchenko@linux.intel.com>
	<CANeU7QnLad1f4KkLpTGSWB8eD8_La-tACim6rR7DLQ=hggwhOQ@mail.gmail.com>
Date: Sun, 29 Jun 2014 00:19:10 -0700
X-Google-Sender-Auth: k26a6I7DSVLQ8C5YLUFiH1iWxxQ
Message-ID: <CANeU7Q=FUTd4XTrQeeFGaSqp7eriZS3egAOqDK--OC-kaWyZuw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] lib.c: skip --param parameters
From: Christopher Li <sparse@chrisli.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux-Sparse <linux-sparse@vger.kernel.org>
Content-Type: multipart/mixed; boundary=001a1132f770dd479904fcf45b40
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a1132f770dd479904fcf45b40
Content-Type: text/plain; charset=ISO-8859-1

Hi Andy,

On Sat, Jun 28, 2014 at 9:59 AM, Christopher Li <sparse@chrisli.org> wrote:
> I think this is problematic.There are three possible input
> from args:
> 1) "--parm", you need to ++next skip to next arg, which is the value for parm.
> 2) "--parm=x",  you don't need to skip to next arg.
> 3) "--parm-with-crap", invalid argument. You don't need to skip next arg.


How about this patch, I modify from your patch.
It fix the problem I mention earlier.

If no objections, I will push the change.

Chris

--001a1132f770dd479904fcf45b40
Content-Type: text/x-patch; charset=US-ASCII; name="0001-lib.c-skip-param-parameters.patch"
Content-Disposition: attachment; 
	filename="0001-lib.c-skip-param-parameters.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hx00yvwn0

RnJvbSBkOTE3NjYyZDU0YmE2OGQwYzNiMDNlOTk0Y2IxZmE2NmQ3YjE5YzMwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbmR5IFNoZXZjaGVua28gPGFuZHJpeS5zaGV2Y2hlbmtvQGxp
bnV4LmludGVsLmNvbT4KRGF0ZTogVHVlLCAxNyBKdW4gMjAxNCAxMjoxMTo0NSArMDMwMApTdWJq
ZWN0OiBbUEFUQ0hdIGxpYi5jOiBza2lwIC0tcGFyYW0gcGFyYW1ldGVycwoKVmVyeSBkdW1iIHBh
dGNoIHRvIGp1c3Qgc2tpcCAtLXBhcmFtIGFsbG93LXN0b3JlLWRhdGEtcmFjZXM9MCBpbnRyb2R1
Y2VkIGluCm5ld2VyIEdDQyB2ZXJzaW9ucy4KCldpdGhvdXQgdGhpcyBwYXRjaCBzcGFyc2UgcmVj
b2duaXplcyBwYXJhbWV0ZXIgb2YgdGhlIC0tcGFyYW0gb3B0aW9uIGFzIGEgZmlsZQpuYW1lIHdo
aWNoIG9idmlvdXNseSBjb3VsZG4ndCBiZSBmb3VuZC4KClNpZ25lZC1vZmYtYnk6IEFuZHkgU2hl
dmNoZW5rbyA8YW5kcml5LnNoZXZjaGVua29AbGludXguaW50ZWwuY29tPgpTaWduZWQtb2ZmLWJ5
OiBDaHJpc3RvcGhlciBMaSA8c3BhcnNlQGNocmlzbGkub3JnPgotLS0KIGxpYi5jIHwgMjQgKysr
KysrKysrKysrKysrKysrKysrKy0tCiAxIGZpbGUgY2hhbmdlZCwgMjIgaW5zZXJ0aW9ucygrKSwg
MiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9saWIuYyBiL2xpYi5jCmluZGV4IDg0NDc5N2Qu
LjBiYzRiMmIgMTAwNjQ0Ci0tLSBhL2xpYi5jCisrKyBiL2xpYi5jCkBAIC02NzUsMjIgKzY3NSw0
MiBAQCBzdGF0aWMgY2hhciAqKmhhbmRsZV92ZXJzaW9uKGNoYXIgKmFyZywgY2hhciAqKm5leHQp
CiAJZXhpdCgwKTsKIH0KIAorc3RhdGljIGNoYXIgKipoYW5kbGVfcGFyYW0oY2hhciAqYXJnLCBj
aGFyICoqbmV4dCkKK3sKKwljaGFyICp2YWx1ZSA9IE5VTEw7CisKKwkvKiBGb3Igbm93IGp1c3Qg
c2tpcCBhbnkgJy0tcGFyYW09Kicgb3IgJy0tcGFyYW0gKicgKi8KKwlpZiAoKmFyZyA9PSAnXDAn
KSB7CisJCXZhbHVlID0gKisrbmV4dDsKKwl9IGVsc2UgaWYgKGlzc3BhY2UoKmFyZykgfHwgKmFy
ZyA9PSAnPScpIHsKKwkJdmFsdWUgPSArK2FyZzsKKwl9CisKKwlpZiAoIXZhbHVlKQorCQlkaWUo
Im1pc3NpbmcgYXJndW1lbnQgZm9yIC0tcGFyYW0gb3B0aW9uIik7CisKKwlyZXR1cm4gbmV4dDsK
K30KKwogc3RydWN0IHN3aXRjaGVzIHsKIAljb25zdCBjaGFyICpuYW1lOwogCWNoYXIgKiooKmZu
KShjaGFyICosIGNoYXIgKiopOworCXVuc2lnbmVkIGludCBwcmVmaXg6MTsKIH07CiAKIHN0YXRp
YyBjaGFyICoqaGFuZGxlX2xvbmdfb3B0aW9ucyhjaGFyICphcmcsIGNoYXIgKipuZXh0KQogewog
CXN0YXRpYyBzdHJ1Y3Qgc3dpdGNoZXMgY21kW10gPSB7CisJCXsgInBhcmFtIiwgaGFuZGxlX3Bh
cmFtLCAxIH0sCiAJCXsgInZlcnNpb24iLCBoYW5kbGVfdmVyc2lvbiB9LAogCQl7IE5VTEwsIE5V
TEwgfQogCX07CiAJc3RydWN0IHN3aXRjaGVzICpzID0gY21kOwogCiAJd2hpbGUgKHMtPm5hbWUp
IHsKLQkJaWYgKCFzdHJjbXAocy0+bmFtZSwgYXJnKSkKLQkJCXJldHVybiBzLT5mbihhcmcsIG5l
eHQpOworCQlpbnQgb3B0bGVuID0gc3RybGVuKHMtPm5hbWUpOworCQlpZiAoIXN0cm5jbXAocy0+
bmFtZSwgYXJnLCBvcHRsZW4gKyAhcy0+cHJlZml4KSkKKwkJCXJldHVybiBzLT5mbihhcmcgKyBv
cHRsZW4sIG5leHQpOwogCQlzKys7CiAJfQogCXJldHVybiBuZXh0OwotLSAKMS45LjMKCg==
--001a1132f770dd479904fcf45b40--
