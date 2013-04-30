Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761251Ab3D3SIl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 14:08:41 -0400
Received: from smtp207.alice.it ([82.57.200.103]:52827 "EHLO smtp207.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760881Ab3D3SIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 14:08:39 -0400
X-Greylist: delayed 353 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Apr 2013 14:08:39 EDT
Message-ID: <B42257E8CA4E4C23957DC087358A7ECA@unknown>
Reply-To: "Roberto CORRADO" <i@secure.corradoroberto.it>
From: "Roberto CORRADO" <i@secure.corradoroberto.it>
To: <johannes@sipsolutions.net>, <IvDoorn@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Fw: kernel BUG at net/rfkill/core.c:244!
Date: Tue, 30 Apr 2013 20:02:53 +0200
MIME-Version: 1.0
Content-Type: multipart/signed;
	protocol="application/x-pkcs7-signature";
	boundary="----=_NextPart_000_0021_01CE45DD.B2CA1480";
	micalg=SHA1
VER: 11
G: L
MTA: SENDMAIL
TY: High
X-Mailer: I'm too lame to use BSD,Linux or Windows
UserAgent: CatWalker by Roberto Corrado Software
RCS: 8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------=_NextPart_000_0021_01CE45DD.B2CA1480
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

[    8.910064] ------------[ cut here ]------------
[    8.911030] kernel BUG at net/rfkill/core.c:244!
[    8.911030] invalid opcode: 0000 [#1] SMP=20
[    8.911030] Modules linked in: hp_wmi(+) psmouse sparse_keymap rfkill =
yenta_socket(+) pcmcia_rsrc pcmcia_core snd_hda_intel(+) snd_hda_codec =
snd_hwdep snd_pcm wmi snd_page_alloc serio_raw snd_timer ehci_pci =
ehci_hcd button battery ac snd soundcore microcode evdev loop reiserfs
[    8.911030] Pid: 1075, comm: udevd Not tainted =
3.9-hp530.corradoroberto.it #1 Hewlett-Packard HP 530 Notebook PC/30D5
[    8.911030] EIP: 0060:[<f85b24dd>] EFLAGS: 00010246 CPU: 1
[    8.911030] EIP is at rfkill_set_hw_state+0x8d/0x90 [rfkill]
[    8.911030] EAX: 00000000 EBX: 00000001 ECX: 00000018 EDX: 00000001
[    8.911030] ESI: 00000000 EDI: f59d0800 EBP: f58b7d20 ESP: f58b7d10
[    8.911030]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[    8.911030] CR0: 8005003b CR2: b76ab200 CR3: 358c7000 CR4: 000007f0
[    8.911030] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[    8.911030] DR6: ffff0ff0 DR7: 00000400
[    8.911030] Process udevd (pid: 1075, ti=3Df58b6000 task=3Df60f0d50 =
task.ti=3Df58b6000)
[    8.911030] Stack:
[    8.911030]  00000004 00000000 f59d080c f59d0800 f58b7d40 f863122f =
f862f0e8 00000003
[    8.911030]  00000f29 f59d080c f862f1d4 f59d0800 f58b7d54 c12dd8ee =
f59d080c f862f1d4
[    8.911030]  f862f1d4 f58b7d78 c12dbcfc f59d080c f862f1d4 f58b7d78 =
c12dd959 f59d080c
[    8.911030] Call Trace:
[    8.911030]  [<f863122f>] hp_wmi_bios_setup+0x22f/0x34d [hp_wmi]
[    8.911030]  [<c12dd8ee>] platform_drv_probe+0x2e/0x60
[    8.911030]  [<c12dbcfc>] driver_probe_device+0x5c/0x1e0
[    8.911030]  [<c12dd959>] ? platform_match+0x39/0x80
[    8.911030]  [<c12dbf31>] __driver_attach+0x71/0x80
[    8.911030]  [<c12dbec0>] ? __device_attach+0x40/0x40
[    8.911030]  [<c12da417>] bus_for_each_dev+0x47/0x80
[    8.911030]  [<c12db8fe>] driver_attach+0x1e/0x20
[    8.911030]  [<c12dbec0>] ? __device_attach+0x40/0x40
[    8.911030]  [<c12db5af>] bus_add_driver+0x1af/0x260
[    8.911030]  [<c12dc4aa>] driver_register+0x6a/0x130
[    8.911030]  [<c12dd51f>] ? platform_device_add+0x10f/0x240
[    8.911030]  [<c12dd740>] platform_driver_register+0x40/0x50
[    8.911030]  [<c12dd7f8>] platform_driver_probe+0x18/0x70
[    8.911030]  [<f86314e1>] hp_wmi_init+0x194/0x1cb [hp_wmi]
[    8.911030]  [<f863134d>] ? hp_wmi_bios_setup+0x34d/0x34d [hp_wmi]
[    8.911030]  [<c10011f2>] do_one_initcall+0x102/0x150
[    8.911030]  [<c105d434>] ? __blocking_notifier_call_chain+0x44/0x60
[    8.911030]  [<c10937ce>] load_module+0x1b5e/0x20a0
[    8.911030]  [<c1093d80>] sys_init_module+0x70/0xa0
[    8.911030]  [<c14c8fdf>] syscall_call+0x7/0xb
[    8.911030]  [<c14c0000>] ? percpu_counter_hotcpu_callback+0x11/0x7a
[    8.911030] Code: e8 69 ff ff ff 80 7e 14 00 74 d8 0f b6 45 f0 83 e0 =
01 38 c3 74 cd 8d 86 00 02 00 00 e8 3d f8 a9 c8 89 f8 83 c4 04 5b 5e 5f =
5d c3 <0f> 0b 90 55 89 e5 3e 8d 74 26 00 8b 80 90 00 00 00 80 78 f4 00
[    8.911030] EIP: [<f85b24dd>] rfkill_set_hw_state+0x8d/0x90 [rfkill] =
SS:ESP 0068:f58b7d10
[    8.920969] ---[ end trace 68e3bab393aad648 ]---

Apr 30 17:38:34 hp530 udevd[1057]: worker [1298] timeout, kill it=20
Apr 30 17:38:34 hp530 udevd[1057]: seq 2519 =
'/devices/virtual/wmi/95F24279-4D7B-4334-9387-ACCDC67EF61C' killed=20
Apr 30 17:38:34 hp530 udevd[1057]: worker [1298] terminated by signal 9 =
(Killed)
------=_NextPart_000_0021_01CE45DD.B2CA1480
Content-Type: application/x-pkcs7-signature;
	name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="smime.p7s"

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIVGjCCBjQw
ggQcoAMCAQICAR4wDQYJKoZIhvcNAQEFBQAwfTELMAkGA1UEBhMCSUwxFjAUBgNVBAoTDVN0YXJ0
Q29tIEx0ZC4xKzApBgNVBAsTIlNlY3VyZSBEaWdpdGFsIENlcnRpZmljYXRlIFNpZ25pbmcxKTAn
BgNVBAMTIFN0YXJ0Q29tIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MB4XDTA3MTAyNDIxMDE1NVoX
DTE3MTAyNDIxMDE1NVowgYwxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSsw
KQYDVQQLEyJTZWN1cmUgRGlnaXRhbCBDZXJ0aWZpY2F0ZSBTaWduaW5nMTgwNgYDVQQDEy9TdGFy
dENvbSBDbGFzcyAxIFByaW1hcnkgSW50ZXJtZWRpYXRlIENsaWVudCBDQTCCASIwDQYJKoZIhvcN
AQEBBQADggEPADCCAQoCggEBAMcJg8zOLdgasSmkLhOrlr6KMoOMpohBllVHrdRvEg/q6r8jR+EK
75xCGhR8ToREoqe7zM9/UnC6TS2y9UKTpT1v7RSMzR0t6ndl0TWBuUr/UXBhPk+Kmy7bI4yW4urC
+y7P3/1/X7U8ocb8VpH/Clt+4iq7nirMcNh6qJR+xjOhV+VHzQMALuGYn5KZmc1NbJQYclsGkDxD
z2UbFqE2+6vIZoL+jb9x4Pa5gNf1TwSDkOkikZB1xtB4ZqtXThaABSONdfmv/Z1pua3FYxnCFmdr
/+N2JLKutIxMYqQOJebr/f/h5t95m4JgrM3Y/w7YX9d7YAL9jvN4SydHsU6n65cCAwEAAaOCAa0w
ggGpMA8GA1UdEwEB/wQFMAMBAf8wDgYDVR0PAQH/BAQDAgEGMB0GA1UdDgQWBBRTcu2SnODaywFc
fH6WNU7y1LhRgjAfBgNVHSMEGDAWgBROC+8apEBbpRdphzDKNGhD0EGu8jBmBggrBgEFBQcBAQRa
MFgwJwYIKwYBBQUHMAGGG2h0dHA6Ly9vY3NwLnN0YXJ0c3NsLmNvbS9jYTAtBggrBgEFBQcwAoYh
aHR0cDovL3d3dy5zdGFydHNzbC5jb20vc2ZzY2EuY3J0MFsGA1UdHwRUMFIwJ6AloCOGIWh0dHA6
Ly93d3cuc3RhcnRzc2wuY29tL3Nmc2NhLmNybDAnoCWgI4YhaHR0cDovL2NybC5zdGFydHNzbC5j
b20vc2ZzY2EuY3JsMIGABgNVHSAEeTB3MHUGCysGAQQBgbU3AQIBMGYwLgYIKwYBBQUHAgEWImh0
dHA6Ly93d3cuc3RhcnRzc2wuY29tL3BvbGljeS5wZGYwNAYIKwYBBQUHAgEWKGh0dHA6Ly93d3cu
c3RhcnRzc2wuY29tL2ludGVybWVkaWF0ZS5wZGYwDQYJKoZIhvcNAQEFBQADggIBAAqDCH14qywG
XLhjjF6uHLkjd02hcdh9hrw+VUsv+q1eeQWB21jWj3kJ96AUlPCoEGZ/ynJNScWy6QMVQjbbMXlt
UfO4n4bGGdKo3awPWp61tjAFgraLJgDk+DsSvUD6EowjMTNx25GQgyYJ5RPIzKKR9tQW8gGK+2+R
HxkUCTbYFnL6kl8Ch507rUdPPipJ9CgJFws3kDS3gOS5WFMxcjO5DwKfKSETEPrHh7p5shuuNktv
sv6hxHTLhiMKX893gxdT3XLS9OKmCv87vkINQcNEcIIoFWbP9HORz9v3vQwR4e3ksLc2JZOAFK+s
sS5XMEoznzpihEP0PLc4dCBYjbvSD7kxgDwZ+Aj8Q9PkbvE9sIPP7ON0fz095HdThKjiVJe6vofq
+n6b1NBc8XdrQvBmunwxD5nvtTW4vtN6VY7mUCmxsCieuoBJ9OlqmsVWQvifIYf40dJPZkk9YgGT
zWLpXDSfLSplbY2LL9C9U0ptvjcDjefLTvqSFc7tw1sEhF0n/qpA2r0GpvkLRDmcSwVyPvmjFBGq
Up/pNy8ZuPGQmHwFi2/14+xeSUDG2bwnsYJQG2EdJCB6luQ57GEnTA/yKZSTKI8dDQa8Sd3zfXb1
9mOgSF0bBdXbuKhEpuP9wirslFe6fQ1t5j5R0xi72MZ8ikMu1RQZKCyDbMwazlHiMIIHETCCBfmg
AwIBAgIDBRuqMA0GCSqGSIb3DQEBCwUAMIGMMQswCQYDVQQGEwJJTDEWMBQGA1UEChMNU3RhcnRD
b20gTHRkLjErMCkGA1UECxMiU2VjdXJlIERpZ2l0YWwgQ2VydGlmaWNhdGUgU2lnbmluZzE4MDYG
A1UEAxMvU3RhcnRDb20gQ2xhc3MgMSBQcmltYXJ5IEludGVybWVkaWF0ZSBDbGllbnQgQ0EwHhcN
MTIxMDE0MDgxOTQyWhcNMTMxMDE1MTU1NzU2WjBQMSMwIQYDVQQDDBppQHNlY3VyZS5jb3JyYWRv
cm9iZXJ0by5pdDEpMCcGCSqGSIb3DQEJARYaaUBzZWN1cmUuY29ycmFkb3JvYmVydG8uaXQwggEi
MA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDAvunSknCJZJ5SdAOHzRPNi3r3a5q9Zp9Mv0AJ
Y29d/MT1e3xZI8ShCCcvydvvd2ahe73LWel0sFb5Z3BEv2Qf6TidaWFq7lkUP7euaSapsbfTyTln
w/F3se4hVDi6RMf/Q2oCi3YNIGnXH2ME3RqBBlmaE4Rj/rguGmbId0ByH460s1zpYh44WVqFUisU
b8PGj4sEUQxP1WSWlB1czAq4b/sCFDJVl4qJxjJAEq0IgHSqp4hQtMBsWjhLZf48YVWHgxvMYr+a
3tWHCkjv2WLZbIQXxhv7X2Dw/5xs/DmjBAAP8P0TzzssX8QcPyVwWmIeAVSCqPYEril36vcqMapb
AgMBAAGjggO1MIIDsTAJBgNVHRMEAjAAMAsGA1UdDwQEAwIEsDAdBgNVHSUEFjAUBggrBgEFBQcD
AgYIKwYBBQUHAwQwHQYDVR0OBBYEFLQSDvkzDBb/q5rGR9m7/IO8PAF/MB8GA1UdIwQYMBaAFFNy
7ZKc4NrLAVx8fpY1TvLUuFGCMCUGA1UdEQQeMByBGmlAc2VjdXJlLmNvcnJhZG9yb2JlcnRvLml0
MIICIQYDVR0gBIICGDCCAhQwggIQBgsrBgEEAYG1NwECAjCCAf8wLgYIKwYBBQUHAgEWImh0dHA6
Ly93d3cuc3RhcnRzc2wuY29tL3BvbGljeS5wZGYwNAYIKwYBBQUHAgEWKGh0dHA6Ly93d3cuc3Rh
cnRzc2wuY29tL2ludGVybWVkaWF0ZS5wZGYwgfcGCCsGAQUFBwICMIHqMCcWIFN0YXJ0Q29tIENl
cnRpZmljYXRpb24gQXV0aG9yaXR5MAMCAQEagb5UaGlzIGNlcnRpZmljYXRlIHdhcyBpc3N1ZWQg
YWNjb3JkaW5nIHRvIHRoZSBDbGFzcyAxIFZhbGlkYXRpb24gcmVxdWlyZW1lbnRzIG9mIHRoZSBT
dGFydENvbSBDQSBwb2xpY3ksIHJlbGlhbmNlIG9ubHkgZm9yIHRoZSBpbnRlbmRlZCBwdXJwb3Nl
IGluIGNvbXBsaWFuY2Ugb2YgdGhlIHJlbHlpbmcgcGFydHkgb2JsaWdhdGlvbnMuMIGcBggrBgEF
BQcCAjCBjzAnFiBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTADAgECGmRMaWFiaWxp
dHkgYW5kIHdhcnJhbnRpZXMgYXJlIGxpbWl0ZWQhIFNlZSBzZWN0aW9uICJMZWdhbCBhbmQgTGlt
aXRhdGlvbnMiIG9mIHRoZSBTdGFydENvbSBDQSBwb2xpY3kuMDYGA1UdHwQvMC0wK6ApoCeGJWh0
dHA6Ly9jcmwuc3RhcnRzc2wuY29tL2NydHUxLWNybC5jcmwwgY4GCCsGAQUFBwEBBIGBMH8wOQYI
KwYBBQUHMAGGLWh0dHA6Ly9vY3NwLnN0YXJ0c3NsLmNvbS9zdWIvY2xhc3MxL2NsaWVudC9jYTBC
BggrBgEFBQcwAoY2aHR0cDovL2FpYS5zdGFydHNzbC5jb20vY2VydHMvc3ViLmNsYXNzMS5jbGll
bnQuY2EuY3J0MCMGA1UdEgQcMBqGGGh0dHA6Ly93d3cuc3RhcnRzc2wuY29tLzANBgkqhkiG9w0B
AQsFAAOCAQEAeiJAe22q+dD4+/zL5F/4ewC5IQNBUoZbA2h3H0lS07F9RZPVk8DvbB5xunxvMzV7
8A3JFH13JzCz0WRvpYtLposA+QpCDVHG22r+uIS4ou0pwCxbStbu7Vol1UF9qLGo2u1vsEzc8Dz8
0Rj98rflCi97d+7Wy8FilrbCwRwkG3F+5dm3EyvDv68qT+c9wkPmkJGFXm5Tp3i2FU981ZGDCDj3
y99I9UjvKFFNEoGbCKqVDf3ypkqQAwPCT+mk+uG22SNS7/pZIpJuB7gvMlwCGtXP4pNh75Q63Pco
HWIYDBQnlEczcJtXjb4OG2zWA9mwnxrCNXgVtaFsASeH36XZujCCB8kwggWxoAMCAQICAQEwDQYJ
KoZIhvcNAQEFBQAwfTELMAkGA1UEBhMCSUwxFjAUBgNVBAoTDVN0YXJ0Q29tIEx0ZC4xKzApBgNV
BAsTIlNlY3VyZSBEaWdpdGFsIENlcnRpZmljYXRlIFNpZ25pbmcxKTAnBgNVBAMTIFN0YXJ0Q29t
IENlcnRpZmljYXRpb24gQXV0aG9yaXR5MB4XDTA2MDkxNzE5NDYzNloXDTM2MDkxNzE5NDYzNlow
fTELMAkGA1UEBhMCSUwxFjAUBgNVBAoTDVN0YXJ0Q29tIEx0ZC4xKzApBgNVBAsTIlNlY3VyZSBE
aWdpdGFsIENlcnRpZmljYXRlIFNpZ25pbmcxKTAnBgNVBAMTIFN0YXJ0Q29tIENlcnRpZmljYXRp
b24gQXV0aG9yaXR5MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAwYjbCbxsRnx4n5V7
tTOQ8nJi1sE2ICIkXs7pd/JDCqIGZKTMjjb4OOYj8G5tsTzdcqOFHKHTPbQzK9Mvr/7qsEFZZ7bE
Bn0KnnSF1nlMgDd63zkFUln39BtGQ6TShYXSw3HzdWI0uiyKfx6P7u000BHHls1SPboz1t1N3gs7
SkufwiYv+rUWHHI1d8o8XebK4SaLGjZ2XAHbdBQl/u21oIgP3XjKLR8HlzABLXJ5+kbWEyqouaar
g0kd5fLv3eQBjhgKj2NTFoViqQ4ZOsy1ZqbCa3QH5Cvhdj60bdj2ROFzYh87xL6gU1YlbFEJ96qr
yr92/W2b853bvz1mvAxWqq+YSJU6S9+nWFDZOHWpW+pDDAL/mevobE1wWyllnN2qXcyvATHsDOvS
jejqnHvmbvcnZgwaSNduQuM/3iE+e+ENcPtjqqhsGlS0XCV6yaLJixamuyx+F14FTVhuEh0B7hIQ
DcYyfxj//PT6zW6R6DZJvhpIaYvClk0aErJpF8EKkNb6eSJIv7p7afhwx/p6N9jYDdJ2T1f/kLfj
kdLd78Jgt2c63f6qnPDUi39yIs7Gn5e2+K+KoBCo2fsYxra1XFI8ibYZKnMBCg8DsxJg8novgduj
bv8mMJf1i92JV7atPbOvK8W3dgLwpdYrmoYUKnL24zOMXQlLE9+7jHQTUksCAwEAAaOCAlIwggJO
MAwGA1UdEwQFMAMBAf8wCwYDVR0PBAQDAgGuMB0GA1UdDgQWBBROC+8apEBbpRdphzDKNGhD0EGu
8jBkBgNVHR8EXTBbMCygKqAohiZodHRwOi8vY2VydC5zdGFydGNvbS5vcmcvc2ZzY2EtY3JsLmNy
bDAroCmgJ4YlaHR0cDovL2NybC5zdGFydGNvbS5vcmcvc2ZzY2EtY3JsLmNybDCCAV0GA1UdIASC
AVQwggFQMIIBTAYLKwYBBAGBtTcBAQEwggE7MC8GCCsGAQUFBwIBFiNodHRwOi8vY2VydC5zdGFy
dGNvbS5vcmcvcG9saWN5LnBkZjA1BggrBgEFBQcCARYpaHR0cDovL2NlcnQuc3RhcnRjb20ub3Jn
L2ludGVybWVkaWF0ZS5wZGYwgdAGCCsGAQUFBwICMIHDMCcWIFN0YXJ0IENvbW1lcmNpYWwgKFN0
YXJ0Q29tKSBMdGQuMAMCAQEagZdMaW1pdGVkIExpYWJpbGl0eSwgcmVhZCB0aGUgc2VjdGlvbiAq
TGVnYWwgTGltaXRhdGlvbnMqIG9mIHRoZSBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0
eSBQb2xpY3kgYXZhaWxhYmxlIGF0IGh0dHA6Ly9jZXJ0LnN0YXJ0Y29tLm9yZy9wb2xpY3kucGRm
MBEGCWCGSAGG+EIBAQQEAwIABzA4BglghkgBhvhCAQ0EKxYpU3RhcnRDb20gRnJlZSBTU0wgQ2Vy
dGlmaWNhdGlvbiBBdXRob3JpdHkwDQYJKoZIhvcNAQEFBQADggIBABZsmfRmDDT10IVefQrs2hBO
OBxe36YlBUuRMsHoO/E93UQJWwdJiinLZgK3sZr3JZgJPI4b4d02hytLu2jTOWY9oCbH8jmRHVGr
gnt+1c5a5OIDV3Bplwj5XlimCt+MBppFFhY4Cl5X9mLHegIF5rwetfKe9Kkpg/iyFONuKIdEw5Aa
3jipPKxDTWRFzt0oqVzyc3sE+Bfoq7HzLlxkbnMxOhK4vLMR5H2PgVGaO42J9E2TZns8A+3Tmh2a
82VQ9aDQdZ8vr/DqgkOY+GmciXnEQ45GcuNkNhKv9yUeOImQd37Da2q5w8tES6x4kIvnxyweSxFE
yDRSJ80KXZ+FwYnVGnjylRBTMt2AhGZ12bVoKPthLr6EqDjAmRKGpR5nZK0GLi+pcIXHlg98iWX1
jkNUDqvdpYA5lGDANMmWcCyjEvUfSHu9HH5rt52Q9CI7rvj8Ksr6glKg769LVZPrwbXwIousNE4m
IgShhyx1SrflfRPXuAxkwDbSyS+GEowjCcEbgjtzSaNqV4eU5dZ4xZlDY+NN4Hct4WWZcmkEGkcJ
5g8BViT7H78OealYLrnECQF+lbptAAY+supKEDnY0Cv1v+x1v5cCxQkbCNxVN+KB+zeEQ2IgyudW
S2Xq/mzBJJMkoTTrBf+aIq6bfT/xZVEKpjBqs/SIHIAN/HKK6INeMYICeTCCAnUCAQEwgZQwgYwx
CzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSswKQYDVQQLEyJTZWN1cmUgRGln
aXRhbCBDZXJ0aWZpY2F0ZSBTaWduaW5nMTgwNgYDVQQDEy9TdGFydENvbSBDbGFzcyAxIFByaW1h
cnkgSW50ZXJtZWRpYXRlIENsaWVudCBDQQIDBRuqMAkGBSsOAwIaBQCggbowGAYJKoZIhvcNAQkD
MQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTMwNDMwMTgwMjUzWjAjBgkqhkiG9w0BCQQx
FgQUMvlgagUCdlL17er5zlJWh8w4oo4wWwYJKoZIhvcNAQkPMU4wTDAKBggqhkiG9w0DBzAOBggq
hkiG9w0DAgICAIAwDQYIKoZIhvcNAwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwBwYFKw4D
Ah0wDQYJKoZIhvcNAQEBBQAEggEAB/OQ+pV4mTVDzw3qOpuWkqpsdZ8yAISAnkv61UIMRazYfDXk
ZyNC/m8+W7kIfaF+ChH4QIFOVyESJfXWRVtRRtF7UxGncBfQPdG64g4rVlIQ+d3Uq105Zn+kgCBV
5O0BQvsTDZX3i4xMKl526ISupLvUjPSkiMklrB/KI24GNpvWiORHSFNN2jvOBA/eLvigTYWly6Xa
59BtOMY810fzmzCCx+Dle0agKvvXFRptZgHZrmn/liynVQF8WiSdP2gyfard6xvEuMKxnsdOoLUg
qSiFTXwJWkkL8UCZk7rXG+dC2d8rXtGhPyyw3iM6Zx9wtW9CrdW5OdmTAZfsUwJ0NwAAAAAAAA==

------=_NextPart_000_0021_01CE45DD.B2CA1480--

